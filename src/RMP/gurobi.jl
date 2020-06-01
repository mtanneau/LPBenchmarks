import Gurobi
const GRBENV = Gurobi.Env()

function run_rmp_gurobi(finst)
    grb = Gurobi.Model(GRBENV, "")
    Gurobi.read_model(grb, finst)

    # Set parameters
    Gurobi.set_int_param!(grb, "OutputFlag", 1)
    Gurobi.set_int_param!(grb, "Threads", 1)
    Gurobi.set_int_param!(grb, "Method", 2)
    Gurobi.set_int_param!(grb, "Crossover", 0)
    Gurobi.set_int_param!(grb, "Presolve", 0)

    # Solve model
    t = @elapsed Gurobi.optimize(grb)

    println("Solve time: $t")
    println("Barrier iterations: ", Gurobi.get_intattr(grb, "BarIterCount"))
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rmp_gurobi(ARGS[1])
end