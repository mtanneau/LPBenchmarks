include(joinpath(@__DIR__, "src/clp.jl"))
include(joinpath(@__DIR__, "src/ecos.jl"))
include(joinpath(@__DIR__, "src/glpk.jl"))
include(joinpath(@__DIR__, "src/tulip.jl"))

fname = joinpath(@__DIR__, "dat/netlib/afiro.mps")

run_clp(fname)
run_ecos(fname)
run_glpk(fname)
run_tulip(fname)