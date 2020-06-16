import Mosek
import MosekTools

include("LPBenchmark.jl")

"""
    run_mosek

Run benchmark for Tulip.
"""
function run_mosek(fname::String)

    # Read file
    mosek = Mosek.Optimizer()
    load_problem!(mosek, fname)

    MOI.set(mosek, MOI.Silent(), false)
    MOI.set(mosek, MOI.TimeLimitSec(), 10_000)
    MOI.set(mosek, MOI.RawParameter("MSK_IPAR_NUM_THREADS"), 1)
    MOI.set(mosek, MOI.RawParameter("MSK_IPAR_INTPNT_BASIS"), 0)
    MOI.set(mosek, MOI.RawParameter("MSK_IPAR_OPTIMIZER"), 4)  # Use the interior-point

    # Solve instance
    run(mosek)

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_mosek(ARGS[1])
end