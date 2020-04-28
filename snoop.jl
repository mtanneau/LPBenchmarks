include(joinpath(@__DIR__, "src/clp.jl"))
include(joinpath(@__DIR__, "src/cplex.jl"))
include(joinpath(@__DIR__, "src/ecos.jl"))
include(joinpath(@__DIR__, "src/glpk.jl"))
include(joinpath(@__DIR__, "src/gurobi.jl"))
include(joinpath(@__DIR__, "src/mosek.jl"))
include(joinpath(@__DIR__, "src/tulip.jl"))

for finst in ["afiro.mps", "25fv47.mps", "pds-02.mps", "qap8.mps", "pilot.mps"]
    fname = joinpath(@__DIR__, "dat/netlib", finst)

    run_clp(fname)
    run_cplex(fname)
    run_ecos(fname)
    run_glpk(fname)
    run_gurobi(fname)
    run_mosek(fname)
    run_tulip(fname)
end