using TimerOutputs
import GLPK

function run_glpk(fname::String)
    timer = TimerOutput()

    glpk = GLPK.Prob()

    @timeit timer "Read" GLPK.read_mps(glpk, 2, fname)

    # TODO: remove integer variables if any

    @timeit timer "Solve" GLPK.interior(glpk)

    # Recover primal solution
    m = GLPK.get_num_rows(glpk)
    n = GLPK.get_num_cols(glpk)
    x = Vector{Float64}(undef, n)
    for j in 1:n
        x[j] = GLPK.ipt_col_prim(glpk, j)
    end

    # TODO: Export solution
    return timer
end

if abspath(PROGRAM_FILE) == @__FILE__
    t = run_glpk(ARGS[1])
    display(t)
    println()
end