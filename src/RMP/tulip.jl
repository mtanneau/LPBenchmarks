using Printf
using LinearAlgebra
BLAS.set_num_threads(1)  # 1 thread only

import Tulip

function run_rmp_tulip(finst)
    tlp = Tulip.Model{Float64}()
    Tulip.load_problem!(tlp, finst)

    # Set parameters
    tlp.params.OutputLevel = 1
    tlp.params.Presolve = 0

    # Solve model
    t = @elapsed Tulip.optimize!(tlp)

    println("Solve time: $t")
    println("Barrier iterations: ", Tulip.get_attribute(tlp, Tulip.BarrierIterations()))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rmp_tulip(ARGS[1])
end