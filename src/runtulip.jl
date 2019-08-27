using LinearAlgebra

import Tulip
TLP = Tulip

"""
    run_tulip

Run benchmark for Tulip.
"""
function run_tulip(finst)

    BLAS.set_num_threads(1)

    m = TLP.Model{Float64}()

    # Read file
    t_read = @elapsed TLP.readmps!(m, finst)

    # Solve instance
    t_solve = @elapsed TLP.optimize!(m)

    # Get objective value
    # TODO: use Tulip interface when released.
    z_opt = m.solver.primal_bound_scaled

    # Done.
    return t_read, t_solve, z_opt

end