using LinearAlgebra

import Gurobi
const GRBENV = Gurobi.Env()

include("LPBenchmark.jl")

function run_gurobi(fname::String, fsol::String="")

    grb = Gurobi.Optimizer(GRBENV)
    bridged = MOIB.full_bridge_optimizer(grb, Float64)

    # Read file
    load_problem!(bridged, fname)

    # MOI parameters
    MOI.set(bridged, MOI.Silent(), false)
    MOI.set(bridged, MOI.TimeLimitSec(), 10_000)
    MOI.set(bridged, MOI.RawParameter("Threads"), 1)
    MOI.set(bridged, MOI.RawParameter("Crossover"), 0)  # No crossover
    MOI.set(bridged, MOI.RawParameter("Method"), 2)  # barrier

    # Solve instance
    run(bridged)
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_gurobi(ARGS[1])
end