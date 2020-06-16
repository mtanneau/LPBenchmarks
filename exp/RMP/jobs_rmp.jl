rmps = readdir(joinpath(@__DIR__, "../dat/rmp"))

for (solver, ext) in [("cplex", :cpx), ("gurobi", :grb), ("mosek", :msk) , ("tulip", :tlp), ("tulip_uba", :tlpu)]
    for frmp in rmps
        println("julia --project --sysimage=JuliaLP.so src/RMP/$(solver).jl dat/rmp/$(frmp) > logs/rmp/$(solver)/$(frmp).$(ext) 2>&1")
    end
end