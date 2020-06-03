using Printf
using Statistics

const LOGDIR = joinpath(@__DIR__, "../logs/rmp")
const RMP_INSTANCES = readdir(joinpath(@__DIR__,  "../dat/rmp"))
const SOLVERS = ["CPLEX", "Gurobi", "Mosek", "Tulip", "Tulip_UBA"]
const SUFFIX = Dict{String, String}(
    "CPLEX" => ".cpx",
    "Gurobi" => ".grb",
    "Mosek" => ".msk",
    "Tulip" => ".tlp",
    "Tulip_UBA" => ".tlpu"
)

function parse_res(flog::String, res=Dict{String, Any}())
    open(flog, "r") do f
        for ln in eachline(f)
            if occursin("Solve time:", ln)
                res["time"] = parse(Float64, split(ln)[end])
                continue
            end
            if occursin("Barrier iterations:", ln)
                res["iter"] = parse(Int, split(ln)[end])
                continue
            end
        end
    end
    return res
end

function parse_all(instances, logdir)
    res_all = Dict()

    for finst in instances
        res_all[finst] = Dict()
        for solver in SOLVERS
            res_all[finst][solver] = Dict()
            # Parse log file
            flog = joinpath(logdir, lowercase(solver), finst*SUFFIX[solver])
            r = parse_res(flog)

            # Check result status
            t = get(r, "time", Inf)
            iter = get(r, "iter", Inf)

            res_all[finst][solver]["time"] = t
            res_all[finst][solver]["iter"] = iter
        end
    end

    return res_all
end

function print_table(res)
    # Header line
    @printf "\\toprule\n"
    @printf "%-16s" "Problem"
    for solver in SOLVERS
        @printf " & \\multicolumn{2}{c}{%s}" solver
    end
    @printf "\\\\\n"
    # @printf "\\midrule\n"

    # Number of instances solved
    # @printf "%-16s" "Solved"
    # for solver in SOLVERS
    #     nsolved = 0
    #     for (finst, r) in res
    #         st = r[solver]["status"]
    #         nsolved += (st == "OPTIMAL" || st == "ALMOST_OPTIMAL")
    #     end
    #     @printf " & %6d" nsolved
    # end
    # @printf "\\\\\n"

    # Average time
    # @printf "%-16s" "Average"
    # for solver in SOLVERS
    #     times = [res[finst][solver]["time"] for finst in RMP_INSTANCES]
    #     μ = gmean(times, 10.0)
    #     @printf " && \\multicolumn{2}{c}{%6.1f}" μ
    # end
    # @printf "\\\\\n"

    # Individual times
    @printf "\\midrule\n"
    for finst in RMP_INSTANCES
        @printf "%-16s" replace(finst[1:end-4], "_" => "\\_")
        # @printf "&&&&"
        for solver in SOLVERS
            # Parse log file
            flog = joinpath(LOGDIR, lowercase(solver), finst*SUFFIX[solver])
            r = parse_res(flog)

            # Check result status
            t = res[finst][solver]["time"]
            iter = res[finst][solver]["iter"]
            titer = t / iter
            @printf " & %5.2f & %3d" t iter
        end

        @printf "\\\\\n"
    end
    @printf "\\bottomrule\n"
    return nothing
end

gmean(u, δ) = exp(mean(log.(u .+ δ))) - δ

if abspath(PROGRAM_FILE) == @__FILE__
    res = parse_all(RMP_INSTANCES, LOGDIR)
    print_table(res)
    return nothing
end