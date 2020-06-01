import Mosek

function run_rmp_mosek(frmp)
    task = Mosek.maketask()
    Mosek.putstreamfunc(task, Mosek.MSK_STREAM_LOG, print)

    Mosek.readdata(task, frmp)

    # Set parameters
    Mosek.putintparam(task, Mosek.MSK_IPAR_NUM_THREADS, 1)
    Mosek.putintparam(task, Mosek.MSK_IPAR_PRESOLVE_USE, 0)
    Mosek.putintparam(task, Mosek.MSK_IPAR_INTPNT_BASIS, 0)
    
    # Solve
    t = @elapsed Mosek.optimize(task)

    println("Solve time: $t")
    println("Barrier iterations: ", Mosek.getintinf(task, Mosek.MSK_IINF_INTPNT_ITER))

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_rmp_mosek(ARGS[1])
end