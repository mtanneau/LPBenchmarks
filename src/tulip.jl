using LinearAlgebra

using TimerOutputs
import Tulip

"""
    run_tulip

Run benchmark for Tulip.
"""
function run_tulip(fname::String)

    timer = TimerOutput()
    BLAS.set_num_threads(1)

    m = Tulip.Model{Float64}()
    m.params.OutputLevel = 1
    m.params.Threads = 1
    m.params.TimeLimit = 10_000

    # Read file
    @timeit timer "Read" Tulip.load_problem!(m, fname)

    # Solve instance
    @timeit timer "Solve" Tulip.optimize!(m)

    # TODO: recover and extract primal solution

    # Display timing info
    println()
    display(timer)
    println()
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_tulip(ARGS[1])
end