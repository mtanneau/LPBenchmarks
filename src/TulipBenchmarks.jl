module TulipBenchmarks

export run_dummy, run_netlib

using Printf

const INSTANCEDIR = joinpath(@__DIR__, "../instances")

include("runtulip.jl")
include("runmosek.jl")


function run_dummy(solvers)
    instances = readdir(joinpath(INSTANCEDIR, "dummy"))
    
    # TODO: header line
    for finst in instances
        @printf "%8s\t" finst[1:end-4]
        for s in solvers
            t_read, t_solve, z_opt = run_any(joinpath(INSTANCEDIR, "dummy", finst), s)
            @printf "%6.2f %6.2f %+16.8e \t" t_read t_solve z_opt
        end
        @printf "\n"
    end
end


function run_netlib(solvers)
    instances = readdir(joinpath(INSTANCEDIR, "netlib"))
    
    # TODO: header line
    for finst in instances
        @printf "%8s\t" finst[1:end-4]
        for s in solvers
            try
                t_read, t_solve, z_opt = run_any(joinpath(INSTANCEDIR, "netlib", finst), s)
                @printf "%6.2f %6.2f %+16.8e \t" t_read t_solve z_opt
            catch err
                @printf "%6s %6s %16s \t" "--" "--" "--"
                @warn "Error with $s on $finst" err
            end
        end
        @printf "\n"
        flush(stdout)
        flush(stderr)
    end
end


function run_any(finst, s)
    if s == :TLP
        run_tulip(finst)
    # elseif s == :GRB
    #     run_gurobi(finst)
    elseif s == :MSK
        run_mosek(finst)
    end
end

end # module
