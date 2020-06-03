# LP benchmarks

Instructions on how to run experiments in the paper.

## Installation

1. Install Julia

2. Install commercial solvers CPLEX, Gurobi and CPLEX
    
3. Instantiate the environment. This will download and build open-source solvers Clp, ECOS, GLPK and Tulip.
    ```julia
    julia> ]
    pkg> instantiate
    ```

## Instances

### Mittelmann benchmark

See [here](https://plato.asu.edu/ftp/lpbar.html).

### Structured master problems 

See instructions at [DER instances](https://github.com/mtanneau/DER_experiments) and [TSSP instances](https://github.com/mtanneau/TSSP.jl) on how to generate the problems.


## Building a sysimage

1. Create pre-compilation statements

Run the `snoop.jl` script at the root of this directory
```bash
julia --trace-compile=precompile.jl --project snoop.jl
```

2. Create the sysimage 

```julia
using PackageCompiler

PackageCompiler.create_sysimage([:MathOptInterface, :Clp, :CPLEX, :ECOS, :GLPK, :Gurobi, :Mosek, :MosekTools, :QPSReader, :Tulip, :DoubleFloats, :LDLFactorizations, :UnitBlockAngular], project=".", sysimage_path="JuliaLP.so", precompile_statements_file="precompile.jl");
```

## Running experiments

### Mittelmann benchmark instances

```bash
julia --sysimage=JuliaLP.so --project src/LP/tulip.jl dat/netlib/afiro.mps
```

### Structured master problems

Single instance:
```bash
julia --sysimage=JuliaLP.so --project src/RMP/tulip.jl dat/rmp/4node_32_10.mps
```

Several instances using GNU parallel:
```bash
julia exp/RMP/jobs_rmp.jl > jobs.txt
cat jobs.txt | parallel -j1 --joblog rmp.log {}
```

### Extended precision

Single instance
```bash
julia --project --sysimage=JuliaLP.so src/D64/tulipD64.jl dat/netlib/afiro.mps 1e-8
julia --project --sysimage=JuliaLP.so src/D64/tulipD64.jl dat/netlib/afiro.mps 1e-16
```

Several instances
```bash
cat exp/D64/failures.txt | parallel -j1 --joblog double64.log 'julia --project --sysimage=JuliaLP.so src/D64/tulipD64.jl dat/plato/{} 1e-8 > {}.log 2>&1'
```