using TimerOutputs
import Clp

function run_clp(fname::String)
    timer = TimerOutput()

    clp = Clp.ClpCInterface.ClpModel()
    options = Clp.ClpCInterface.ClpSolve()

    Clp.ClpCInterface.set_solve_type(options, 4)  # barrier, no crossover

    @timeit timer "Read" Clp.ClpCInterface.read_mps(clp, fname)

    # TODO: remove integer variables if any
    Clp.ClpCInterface.set_maximum_seconds(clp, 10_000)
    @timeit timer "Solve" Clp.ClpCInterface.initial_solve_with_options(clp, options)

    # TODO: extract solver status and solution
    st = Clp.status(clp)
    print("\n\nClp status: ")
    if st == 0
        println("0 - optimal")
    elseif st == 1
        println("1 - primal infeasible")
    elseif st == 2
        println("2 - dual infeasible")
    elseif st == 3
        println("3 - stopped on iterations etc")
    elseif st == 4
        println("4 - stopped due to errors")
    else
        println("Expected integer in [0, 4] but got $st")
    end


    # Display timing info
    flush(stdout)
    flush(stderr)
    sleep(0.10)
    println()
    display(timer)
    println()
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_clp(ARGS[1])
end