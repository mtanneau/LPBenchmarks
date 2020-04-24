using TimerOutputs
import Mosek

"""
    run_mosek

Run benchmark for Tulip.
"""
function run_mosek(fname::String)

    timer = TimerOutput()

    # Read file
    @timeit timer "Read" task = Mosek.maketask(filename=fname)

    # Activate output
    Mosek.putstreamfunc(task, Mosek.MSK_STREAM_LOG, print)
    Mosek.putintparam(task, Mosek.MSK_IPAR_INTPNT_BASIS, 0)
    Mosek.putintparam(task, Mosek.MSK_IPAR_NUM_THREADS, 1)
    Mosek.putdouparam(task, Mosek.MSK_DPAR_OPTIMIZER_MAX_TIME, 10_000)

    # Solve instance
    @timeit timer "Solve" Mosek.optimize(task)

    # TODO: recover solver status and solution

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
    run_mosek(ARGS[1])
end