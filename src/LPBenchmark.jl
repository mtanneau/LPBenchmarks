import MathOptInterface
const MOI = MathOptInterface
const MOIB = MOI.Bridges
const MOIU = MOI.Utilities
const MOIF = MOI.FileFormats

function load_problem!(m::MOI.AbstractOptimizer, fname::String)
    MOI.empty!(m)

    # Read problem from MPS file
    mps = MOIF.MPS.Model()
    MOI.read_from_file(mps, fname)

    # Remove all integer constraints
    l = MOI.get(mps, MOI.ListOfConstraints())
    for cidx in MOI.get(mps, MOI.ListOfConstraintIndices{MOI.SingleVariable, MOI.Integer}())
        MOI.delete(mps, cidx)
    end
    for cidx in MOI.get(mps, MOI.ListOfConstraintIndices{MOI.SingleVariable, MOI.ZeroOne}())
        MOI.delete(mps, cidx)
        # Add lower and upper bounds
        v = cidx.value
        MOI.add_constraint(mps, MOI.SingleVariable(v), MOI.GreaterThan(0.0))
        MOI.add_constraint(mps, MOI.SingleVariable(v), MOI.LessThan(1.0))
    end

    # Set the objective to be 
    Tobj = MOI.get(mps, MOI.ObjectiveFunctionType())
    if Tobj != MOI.ScalarAffineFunction{Float64}
        fobj = MOI.get(mps, MOI.ObjectiveFunction{Tobj}())
        # convert to ScalarAffine
        fobj_ = MOI.ScalarAffineFunction{Float64}(fobj)
        MOI.set(mps, MOI.ObjectiveFunction{typeof(fobj_)}(), fobj_)
    end

    # Copy model
    MOI.copy_to(m, mps, copy_names=false)

    return m
end

function run(model::MOI.AbstractOptimizer)
    println("Solver name: ", MOI.get(model, MOI.SolverName()))
    try
        tsolve = @elapsed MOI.optimize!(model)

        # TODO: export solution
        # We can't do that since MOI's MPS reader may not be consistent between runs
        println("Solve time: ", tsolve)
        println("Termination status: ", MOI.get(model, MOI.TerminationStatus()))
        rcount = MOI.get(model, MOI.ResultCount())
        println("Result count: ", rcount)
        if rcount > 0
            println("Primal status: ", MOI.get(model, MOI.PrimalStatus()))
            println("Dual status: ", MOI.get(model, MOI.DualStatus()))
        end
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
    end
end