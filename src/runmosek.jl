import Mosek

"""
    run_mosek

Run benchmark for Tulip.
"""
function run_mosek(finst)

    # Read file
    t_read = @elapsed task = Mosek.maketask(filename=finst)

    # Set parameters
    # TODO: provide parameters as arguments
    Mosek.putintparam(task, Mosek.MSK_IPAR_NUM_THREADS, 1)

    # Solve instance
    t_solve = @elapsed Mosek.optimize(task)

    # Get objective value
    # TODO: use Tulip interface when released.
    z_opt = Mosek.getprimalobj(task, Mosek.MSK_SOL_ITR)

    # Done.
    return t_read, t_solve, z_opt

end