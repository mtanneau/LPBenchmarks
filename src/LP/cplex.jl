using LinearAlgebra

import CPLEX

include("LPBenchmark.jl")

function run_cplex(fname::String, fsol::String="")

    cplex = CPLEX.Optimizer()
    bridged = MOIB.full_bridge_optimizer(cplex, Float64)

    # Read file
    load_problem!(bridged, fname)

    # MOI parameters
    MOI.set(bridged, MOI.Silent(), false)
    MOI.set(bridged, MOI.TimeLimitSec(), 10_000)
    MOI.set(bridged, MOI.RawParameter("CPXPARAM_Threads"), 1)  # Single threads
    MOI.set(bridged, MOI.RawParameter("CPXPARAM_SolutionType"), 2)  # No crossover
    MOI.set(bridged, MOI.RawParameter("CPXPARAM_LPMethod"), 4)  # barrier

    # Solve instance
    run(bridged)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_cplex(ARGS[1])
end