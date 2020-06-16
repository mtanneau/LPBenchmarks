using Printf
using LinearAlgebra
BLAS.set_num_threads(1)  # 1 thread only

import Tulip
using DoubleFloats

function tulip_d64(finst, ϵ)
    tlp = Tulip.Model{Double64}()
    Tulip.load_problem!(tlp, finst)

    # Set parameters
    tlp.params.OutputLevel = 1
    tlp.params.Presolve = 1
    tlp.params.BarrierIterationsLimit = 500

    # Set tolerances
    tlp.params.BarrierTolerancePFeas = ϵ
    tlp.params.BarrierToleranceDFeas = ϵ
    tlp.params.BarrierToleranceRGap = ϵ
    tlp.params.BarrierToleranceIFeas = ϵ / 100

    # Solve model
    t = @elapsed Tulip.optimize!(tlp)

    println("Solve time: $t")
    println("Barrier iterations: ", Tulip.get_attribute(tlp, Tulip.BarrierIterations()))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    ϵ = parse(Double64, ARGS[2])
    tulip_d64(ARGS[1], ϵ)
end