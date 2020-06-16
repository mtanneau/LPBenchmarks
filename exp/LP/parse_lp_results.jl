using Printf
using Statistics

const LOGDIR = joinpath(@__DIR__, "../../logs/mittelman")
const PLATO_INSTANCES = readlines(joinpath(@__DIR__, "../plato.txt"))
const SOLVERS = ["Clp", "CPLEX", "ECOS", "GLPK", "Gurobi", "Mosek", "Tulip"]
const SUFFIX = Dict{String, String}(
    "Clp" => ".clp",
    "CPLEX" => ".cpx",
    "ECOS" => ".ecos",
    "GLPK" => ".glpk",
    "Gurobi" => ".grb",
    "Mosek" => ".msk",
    "Tulip" => ".tlp"
)

gmean(u, δ) = exp(mean(log.(u .+ δ))) - δ

function parse_res(flog::String, res=Dict{String, Any}())
    res["segfault"] = false
    open(flog, "r") do f
        for ln in eachline(f)
            if occursin("Solver name:", ln)
                res["solver"] = split(ln)[3]
                continue
            end
            if occursin("Solve time:", ln)
                res["time"] = parse(Float64, split(ln)[3])
                continue
            end
            if occursin("Termination status:", ln)
                res["status"] = split(ln)[3]
                continue
            end
            if occursin("Result count:", ln)
                res["rescount"] = split(ln)[3]
                continue
            end
            if occursin("Primal status:", ln)
                res["primal_status"] = split(ln)[3]
                continue
            end
            if occursin("Dual status:", ln)
                res["dual_status"] = split(ln)[3]
                continue
            end
            if occursin("Segmentation fault", ln)
                res["segfault"] = true
            end
        end
    end
    return res
end

function parse_all(instances, logdir)

    # TODO: parse all results in a single dict
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
            st = get(r, "status", "ERROR")

            if solver == "Gurobi" && st == "OTHER_LIMIT"
                st = "ALMOST_OPTIMAL"
            end
            if solver == "Clp" && st == "OTHER_LIMIT" && t >= 10_000
                st = "TIME_LIMIT"
            end

            res_all[finst][solver]["time"] = (st == "OPTIMAL" || st == "ALMOST_OPTIMAL") ? min(t, 10_000) : 10_000
            res_all[finst][solver]["status"] = st
            res_all[finst][solver]["segfault"] = r["segfault"]
        end
    end

    return res_all
end

function print_table(res)
    # TODO: count number of success for each solver, and geometric mean of total time
    # Header line
    @printf "\\toprule\n"
    @printf "%-16s" "Problem"
    for solver in SOLVERS
        @printf " & %6s" solver
    end
    @printf "\\\\\n"
    @printf "\\midrule\n"

    # Number of instances solved
    @printf "%-16s" "Solved"
    for solver in SOLVERS
        nsolved = 0
        for (finst, r) in res
            st = r[solver]["status"]
            nsolved += (st == "OPTIMAL" || st == "ALMOST_OPTIMAL")
        end
        @printf " & %6d" nsolved
    end
    @printf "\\\\\n"

    # Average time
    @printf "%-16s" "Average"
    for solver in SOLVERS
        times = [res[finst][solver]["time"] for finst in PLATO_INSTANCES]
        μ = gmean(times, 10.0)
        @printf " & %6.1f" μ
    end
    @printf "\\\\\n"

    # Individual times
    @printf "\\midrule\n"
    for finst in sort(PLATO_INSTANCES)
        @printf "%-16s" replace(finst[1:end-4], "_" => "\\_")
        for solver in SOLVERS
            @printf " & "
            # Parse log file
            flog = joinpath(LOGDIR, lowercase(solver), finst*SUFFIX[solver])
            r = parse_res(flog)

            # Check result status
            t = res[finst][solver]["time"]
            st = res[finst][solver]["status"]
            segfault = res[finst][solver]["segfault"]
            
            if segfault
                @printf "%s" "\\texttt{seg}"
            elseif t < 10_000 && st == "OPTIMAL"
                # Problem was solved within the time limit
                @printf "%6.1f" t
            elseif t < 10_000 && st == "ALMOST_OPTIMAL"
                @printf "%6.1f\\texttt{r}" t
            elseif st == "TIME_LIMIT"
                # Time limit reached
                @printf "%6s" "\\texttt{t}"
            else
                # Other error
                @printf "%6s" "\\texttt{f}"
            end
        end

        @printf "\\\\\n"
    end
    @printf "\\bottomrule\n"
    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    res = parse_all(PLATO_INSTANCES, LOGDIR)
    print_table(res)
    return nothing
end