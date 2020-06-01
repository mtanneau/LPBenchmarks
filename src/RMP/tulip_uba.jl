using LinearAlgebra
using SparseArrays
using Logging
BLAS.set_num_threads(1)  # 1 thread only

using QPSReader

import Tulip
using UnitBlockAngular

function run_rmp_tulip_uba(frmp)
    finst = split(frmp, '/')[end]

    # Check if DER or TSSP instance
    if finst[1:3] == "DER"
        R = parse(Int, split(finst, '_')[3])
    else
        # TSSP
        R = parse(Int, split(finst, r"_|\.")[2])
    end

    
    # Read RMP
    qps = with_logger(Logging.NullLogger()) do
        readqps(frmp)
    end
    
    # Problem stats:
    #   * linking constraints
    #   * linking variables
    #   * Number of sub-problems
    #   * Density of lower blocks
    M = qps.ncon
    N = qps.nvar
    m0 = M - R
    
    nz = 0
    blockidx = zeros(Int, N)
    for (i, j, v) in zip(qps.arows, qps.acols, qps.avals)
        if 1 <= i <= m0
            nz += 1 
        else
            @assert blockidx[j] == 0
            blockidx[j] = i - m0
        end
    end
    n0 = sum(blockidx .== 0)
    
    # Sort columns
    perm = sortperm(blockidx)
    iperm = invperm(perm)
        
    # Re-order columns and load model
    acols_ = copy(qps.acols)
    for (k, j) in enumerate(qps.acols)
        acols_[k] = iperm[j]
    end
    
    tlp = Tulip.Model{Float64}()
    Tulip.load_problem!(tlp.pbdata,
        qps.name,
        true, qps.c[perm], qps.c0,
        sparse(qps.arows, acols_, qps.avals, qps.ncon, qps.nvar),
        qps.lcon, qps.ucon,
        qps.lvar[perm], qps.uvar[perm],
        qps.connames, qps.varnames[perm]
    )

    # Set parameters
    tlp.params.OutputLevel = 1
    tlp.params.Presolve = 0

    # Set custom KKT options
    tlp.params.MatrixOptions = Tulip.TLA.MatrixOptions(UnitBlockAngularMatrix, m0=m0, n0=n0, n=N-n0, R=R)
    tlp.params.KKTOptions = Tulip.KKT.SolverOptions(UnitBlockAngularFactor)

    # Solve model
    t = @elapsed Tulip.optimize!(tlp)

    println("Solve time: $t")
    println("Barrier iterations: ", Tulip.get_attribute(tlp, Tulip.BarrierIterations()))
    
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rmp_tulip_uba(ARGS[1])
end