using Printf
using Statistics

const LOGDIR = joinpath(@__DIR__, "../../logs/rmp")
const RMP_INSTANCES = readdir(joinpath(@__DIR__,  "../../dat/rmp"))
const SOLVERS = ["CPLEX", "Gurobi", "Mosek", "Tulip", "Tulip_UBA"]
const SUFFIX = Dict{String, String}(
    "CPLEX" => ".cpx",
    "Gurobi" => ".grb",
    "Mosek" => ".msk",
    "Tulip" => ".tlp",
    "Tulip_UBA" => ".tlpu"
)
const SOLVERS_SHORT = Dict{String, String}(
    "CPLEX" => "CPX",
    "Gurobi" => "GRB",
    "Mosek" => "MSK",
    "Tulip" => "TLP",
    "Tulip_UBA" => "TLP*"
)

function parse_logname(finst)
    if finst[1:3] == "DER"
        fname, T, R, cg = split(finst, r"_|\.")[1:4]
        fname = "DER_$T"
    else
        fname, R, cg = split(finst, r"_|\.")[1:3]
    end
    R = parse(Int, R)
    cg = parse(Int, cg)
    return fname, R, cg
end

# Get number of CG iterations for each instance
function extract_cg_iter(instances)
    CG_ITER = Dict{Tuple{String, Int}, Int}()

    for finst in instances
        fname, R, cg = parse_logname(finst)
        cg_ = get(CG_ITER, (fname, R), 0)
        if cg > cg_
            CG_ITER[fname, R] = cg
        end
    end
    return CG_ITER
end

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

        fname, R, cg = parse_logname(finst)

        res_all[fname, R, cg] = Dict()
        for solver in SOLVERS
            res_all[fname, R, cg][solver] = Dict()
            # Parse log file
            flog = joinpath(logdir, lowercase(solver), finst*SUFFIX[solver])
            r = parse_res(flog)

            # Check result status
            t = get(r, "time", Inf)
            iter = get(r, "iter", Inf)

            res_all[fname, R, cg][solver]["time"] = t
            res_all[fname, R, cg][solver]["iter"] = iter
        end
    end

    return res_all
end

function print_table(res, last_only::Bool=false)
    # Header line
    @printf "\\toprule\n"    
    @printf "%-16s &   \$R\$" "Problem"
    last_only || @printf " & CG"
    for solver in SOLVERS
        @printf " & \\multicolumn{2}{c}{%s}" solver
    end
    @printf "\\\\\n"

    CG_ITER = extract_cg_iter(RMP_INSTANCES)

    # Individual times
    @printf "\\midrule\n"
    KEYS = sort(collect(keys(res)))
    for (fname, R, cg) in KEYS

        if last_only
            cg == CG_ITER[fname, R] || continue
        end

        @printf "%-16s & %5d" replace(fname, "_" => "-") R
        last_only || @printf " & %2d" cg
        finst = "$(fname)_$(R)_$(cg).mps"

        # Time
        tmin = minimum([res[fname, R, cg][solver]["time"] for solver in SOLVERS])
        for solver in SOLVERS
            # Parse log file
            flog = joinpath(LOGDIR, lowercase(solver), finst*SUFFIX[solver])
            r = parse_res(flog)

            # Check result status
            t = res[fname, R, cg][solver]["time"]
            iter = res[fname, R, cg][solver]["iter"]
            titer = t / iter
            if t == tmin
                
                @printf " & \\textbf{%6.1f} & %3d & %6.3f" t iter titer
            else
                @printf " & %6.1f & %3d & %6.3f" t iter titer
            end
        end

        @printf "\\\\\n"
    end
    @printf "\\bottomrule\n"
    return nothing
end

gmean(u, δ) = exp(mean(log.(u .+ δ))) - δ

if abspath(PROGRAM_FILE) == @__FILE__
    res = parse_all(RMP_INSTANCES, LOGDIR)
    print_table(res, true)
    return nothing
end