using LinearAlgebra

import CPLEX

include("LPBenchmark.jl")

function run_cplex(fname::String, fsol::String="")

    cplex = CPLEX.Optimizer()

    # Read file
    load_problem!(cplex, fname)

    # MOI parameters
    MOI.set(cplex, MOI.Silent(), false)
    MOI.set(cplex, MOI.TimeLimitSec(), 10_000)
    MOI.set(cplex, MOI.RawParameter("CPXPARAM_Threads"), 1)  # Single threads
    MOI.set(cplex, MOI.RawParameter("CPXPARAM_SolutionType"), 2)  # No crossover
    MOI.set(cplex, MOI.RawParameter("CPXPARAM_LPMethod"), 4)  # barrier

    # Solve instance
    run(cplex)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_cplex(ARGS[1])
end