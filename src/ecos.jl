using TimerOutputs

import MathOptInterface

const MOI = MathOptInterface
const MOIB = MOI.Bridges
const MOIU = MOI.Utilities
const MOIF = MOI.FileFormats

import ECOS

function run_ecos(fname::String)
    timer = TimerOutput()

    ecos = ECOS.Optimizer()
    cache = MOIU.UniversalFallback(MOIU.Model{Float64}())
    cached = MOIU.CachingOptimizer(cache, ecos)
    bridged = MOIB.full_bridge_optimizer(cached, Float64)

    # Read problem
    mps = MOIF.MPS.Model();
    @timeit timer "Read" MOI.read_from_file(mps, fname)

    MOI.empty!(bridged)
    @timeit timer "Copy" MOI.copy_to(bridged, mps, copy_names=false)

    # Solve the problem
    # Note: this will (i) convert the data to ECOS' format (ii) solve
    # ECOS' internal solve time (excluding conversion) is displayed in log
    @timeit timer "Solve" MOI.optimize!(bridged)

    # Display timing info
    println()
    display(timer)
    println()
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_ecos(ARGS[1])
end