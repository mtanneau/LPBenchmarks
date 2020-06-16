import GLPK

include("LPBenchmark.jl")

function run_glpk(fname::String)
    glpk = GLPK.Optimizer(method=GLPK.INTERIOR)
    bridged = MOIB.full_bridge_optimizer(glpk, Float64)

    load_problem!(bridged, fname)

    MOI.set(bridged, MOI.TimeLimitSec(), 10_000)
    MOI.set(bridged, MOI.RawParameter("msg_lev"), 3)

    # Solve the problem
    run(bridged)

    # Display timing info
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_glpk(ARGS[1])
end