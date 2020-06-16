Coin0506I Presolve 377506 (-150679) rows, 1034737 (-224384) columns and 2863600 (-478096) elements
1.31541e+09 elements in sparse Cholesky, flop count 7.35675e+13

signal (11): Segmentation fault
in expression starting at /home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks/src/clp.jl:24
_ZN16ClpCholeskyDense14factorizePart2EPi at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
_ZN15ClpCholeskyBase14factorizePart2EPi at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
_ZN15ClpCholeskyBase9factorizeEPKdPi at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
_ZN21ClpPredictorCorrector14createSolutionEv at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
_ZN21ClpPredictorCorrector5solveEv at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
_ZN10ClpSimplex12initialSolveER8ClpSolve at /home/mtanneau/.julia/artifacts/0cb53fd47e94da72ef05b3846e0e3d509c1f3df9/lib/libClp.so (unknown line)
Clp_initialSolveWithOptions at /home/mtanneau/.julia/packages/Clp/OkDsO/src/gen/libclp_api.jl:369 [inlined]
optimize! at /home/mtanneau/.julia/packages/Clp/OkDsO/src/MOI_wrapper/MOI_wrapper.jl:305 [inlined]
optimize! at /home/mtanneau/.julia/packages/MathOptInterface/RmalA/src/Utilities/cachingoptimizer.jl:189
optimize! at /home/mtanneau/.julia/packages/MathOptInterface/RmalA/src/Bridges/bridge_optimizer.jl:239 [inlined]
macro expansion at ./util.jl:234 [inlined]
run at /home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks/src/LPBenchmark.jl:45
run_clp at /home/mtanneau/projects/def-alodi/mtanneau/LPBenchmarks/src/clp.jl:18
_jl_invoke at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/gf.c:2158 [inlined]
jl_apply_generic at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/gf.c:2322
jl_apply at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/julia.h:1700 [inlined]
do_call at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/interpreter.c:369
eval_value at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/interpreter.c:458
eval_stmt_value at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/interpreter.c:409 [inlined]
eval_body at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/interpreter.c:817
jl_interpret_toplevel_thunk at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/interpreter.c:911
jl_toplevel_eval_flex at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/toplevel.c:814
jl_parse_eval_all at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/ast.c:872
jl_load at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/toplevel.c:872
include at ./Base.jl:377
exec_options at ./client.jl:288
_start at ./client.jl:484
jfptr__start_25435 at /lustre03/project/6005065/mtanneau/LPBenchmarks/JuliaLP.so (unknown line)
_jl_invoke at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/gf.c:2144 [inlined]
jl_apply_generic at /tmp/ebuser/avx512/Julia/1.4.1/GCC-7.3.0/julia-1.4.1/src/gf.c:2322
unknown function (ip: 0x4018e1)
unknown function (ip: 0x401513)
__libc_start_main at /cvmfs/soft.computecanada.ca/nix/store/63pk88rnmkzjblpxydvrmskkc8ci7cx6-glibc-2.24/lib/libc.so.6 (unknown line)
unknown function (ip: 0x4015b9)
Allocations: 522095341 (Pool: 522094522; Big: 819); GC: 61
