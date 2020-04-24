# LP benchmarks

## Installation

1. Install Julia
2. Install commercial solvers
3. Clp and Tulip need a special branch (for now)
    ```julia
    pkg> add Clp#master
    pkg> add Tulip#Presolve
    ```
    
3. Instantiate the environment. This will download and build open-source solvers Clp, ECOS, GLPK and Tulip.

## Download instances

### Mittelmann benchmark

### Problematic instances

## Running with a sysimage

1. Create pre-compilation statements

Run the `snoop.jl` script at the root of this directory
```bash
julia --trace-compile=precompile.jl --project snoop.jl
```

2. Create the sysimage 

```julia
julia> using PackageCompiler
julia> PackageCompiler.create_sysimage([:MathOptInterface, :TimerOutputs, :Clp, :ECOS, :GLPK, :Mosek, :Tulip], project=".", sysimage_path="JuliaLP.so", precompile_statements_file="precompile.jl");
```

3. Running the script

```bash
julia --sysimage=JuliaLP.so --project src/tulip.jl dat/netlib/afiro.mps
```