import ECOS

include("LPBenchmark.jl")

function run_ecos(fname::String, fsol::String="")

    ecos = ECOS.Optimizer()
    cache = MOIU.UniversalFallback(MOIU.Model{Float64}())
    cached = MOIU.CachingOptimizer(cache, ecos)
    bridged = MOIB.full_bridge_optimizer(cached, Float64)

    # Read problem
    load_problem!(bridged, fname)

    # Set some parameters
    MOI.set(bridged, MOI.Silent(), false)

    # Solve the problem
    # Note: this will (i) convert the data to ECOS' format (ii) solve
    # ECOS' internal solve time (excluding conversion) is displayed in log
    run(bridged)

    # Display timing info
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_ecos(ARGS[1])
end