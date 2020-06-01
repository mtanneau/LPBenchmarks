import CPLEX

function run_rmp_cplex(frmp)

    CPXENV = CPLEX.Env()

    # Set parameters
    CPLEX.set_param!(CPXENV, "CPXPARAM_ScreenOutput", 1)
    CPLEX.set_param!(CPXENV, "CPXPARAM_TimeLimit", 3600)
    CPLEX.set_param!(CPXENV, "CPXPARAM_Threads", 1)  # Single threads
    CPLEX.set_param!(CPXENV, "CPXPARAM_SolutionType", 2)  # No crossover
    CPLEX.set_param!(CPXENV, "CPXPARAM_LPMethod", 4)  # barrier
    CPLEX.set_param!(CPXENV, "CPXPARAM_Preprocessing_Presolve", 0)  # No presolve
    cplex = CPLEX.Model(CPXENV)

    # Read file
    CPLEX.read_model(cplex, frmp)

    # Solve instance
    t = @elapsed CPLEX.optimize!(cplex)

    println("Solve time: $t")
    println("Barrier iterations: ", CPLEX.c_api_getbaritcnt(cplex))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rmp_cplex(ARGS[1])
end