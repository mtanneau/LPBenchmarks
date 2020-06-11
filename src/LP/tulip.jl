using LinearAlgebra

import Tulip

include("LPBenchmark.jl")

"""
    run_tulip

Run benchmark for Tulip.
"""
function run_tulip(fname::String, fsol::String="")

    BLAS.set_num_threads(1)

    tulip = Tulip.Optimizer()

    # Read file
    load_problem!(tulip, fname)
    MOI.set(tulip, MOI.Silent(), false)
    MOI.set(tulip, MOI.NumberOfThreads(), 1)
    MOI.set(tulip, MOI.TimeLimitSec(), 10_000)
    MOI.set(tulip, MOI.RawParameter("BarrierIterationsLimit"), 500)

    # Solve instance
    run(tulip)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_tulip(ARGS[1])
end