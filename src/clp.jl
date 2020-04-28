import Clp

include("LPBenchmark.jl")

function run_clp(fname::String)
    clp = Clp.Optimizer()
    
    load_problem!(clp, fname)

    # Set some parameters
    MOI.set(clp, MOI.TimeLimitSec(), 10_000)
    MOI.set(clp, MOI.RawParameter("SolveType"), 4)  # barrier, no crossover

    # Solve the problem
    run(clp)

    # Display timing info
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_clp(ARGS[1])
end