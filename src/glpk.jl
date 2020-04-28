import GLPK

include("LPBenchmark.jl")

function run_glpk(fname::String)
    glpk = GLPK.Optimizer(method=GLPK.INTERIOR)

    load_problem!(glpk, fname)

    MOI.set(glpk, MOI.TimeLimitSec(), 10_000)
    MOI.set(glpk, MOI.RawParameter("msg_lev"), 3)

    # Solve the problem
    run(glpk)

    # Display timing info
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_glpk(ARGS[1])
end