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

    # Display timing info
    println()
    display(timer)
    println()
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_glpk(ARGS[1])
end