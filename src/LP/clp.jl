import Clp

include("LPBenchmark.jl")

function run_clp(fname::String)
    clp = Clp.Optimizer()
    cache = MOIU.UniversalFallback(MOIU.Model{Float64}())
    cached = MOIU.CachingOptimizer(cache, clp)
    bridged = MOIB.full_bridge_optimizer(cached, Float64)

    load_problem!(bridged, fname)

    # Set some parameters
    MOI.set(bridged, MOI.TimeLimitSec(), 10_000)
    MOI.set(bridged, MOI.RawParameter("SolveType"), 4)  # barrier, no crossover

    # Solve the problem
    run(bridged)

    # Display timing info
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_clp(ARGS[1])
end