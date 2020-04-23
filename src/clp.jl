using TimerOutputs
import Clp

function run_clp(fname::String)
    timer = TimerOutput()

    clp = Clp.ClpCInterface.ClpModel()

    @timeit timer "Read" Clp.ClpCInterface.read_mps(clp, fname)

    # TODO: remove integer variables if any

    @timeit timer "Solve" Clp.ClpCInterface.initial_barrier_no_cross_solve(clp)

    # TODO: get solution & export it
    return timer
end

if abspath(PROGRAM_FILE) == @__FILE__
    t = run_clp(ARGS[1])
    display(t)
    println()
end