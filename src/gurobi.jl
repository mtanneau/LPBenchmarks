using LinearAlgebra

import Gurobi
const GRBENV = Gurobi.Env()

include("LPBenchmark.jl")

function run_gurobi(fname::String, fsol::String="")

    grb = Gurobi.Optimizer(GRBENV)

    # Read file
    load_problem!(grb, fname)

    # MOI parameters
    MOI.set(grb, MOI.Silent(), false)
    MOI.set(grb, MOI.TimeLimitSec(), 10_000)
    MOI.set(grb, MOI.RawParameter("Threads"), 1)
    MOI.set(grb, MOI.RawParameter("Crossover"), 0)  # No crossover
    MOI.set(grb, MOI.RawParameter("Method"), 2)  # barrier

    # Solve instance
    run(grb)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_gurobi(ARGS[1])
end