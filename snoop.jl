# Mittelman instances
include(joinpath(@__DIR__, "src/LP/clp.jl"))
include(joinpath(@__DIR__, "src/LP/cplex.jl"))
include(joinpath(@__DIR__, "src/LP/ecos.jl"))
include(joinpath(@__DIR__, "src/LP/glpk.jl"))
include(joinpath(@__DIR__, "src/LP/gurobi.jl"))
include(joinpath(@__DIR__, "src/LP/mosek.jl"))
include(joinpath(@__DIR__, "src/LP/tulip.jl"))

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


# Structured LP instances
include("src/RMP/cplex.jl")
include("src/RMP/gurobi.jl")
include("src/RMP/mosek.jl")
include("src/RMP/tulip.jl")
include("src/RMP/tulip_uba.jl")

for finst in ["DER_24_1024_10.mps"]
    frmp = joinpath(@__DIR__, "dat/rmp", finst)

    run_rmp_cplex(frmp)
    run_rmp_gurobi(frmp)
    run_rmp_mosek(frmp)
    run_rmp_tulip(frmp)
    run_rmp_tulip_uba(frmp)
end

# Extended precision
include("src/D64/tulipD64.jl")

tulip_d64(joinpath(@__DIR__, "dat/plato/brazil3.mps"), 1e-8)