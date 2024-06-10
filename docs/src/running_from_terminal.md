```@meta
CurrentModule = ABCredit 
```

# Running the model from the terminal

You can run the model from the terminal without activating
the Julia environment via

```shell
julia --project=. main.jl
```

The `main.jl` runs the model with a set of standard parameter, if you want
to specify a different set of parameters directly from the command line you
can run

```shell
julia --project=. main_st_in_out.jl par1 par2 ... par33
```

the results of the run will be saved in a CSV. Check the `main_st_in_out.jl`
file for details.

If you need to call the model many times with a different set of parameters
e.g., if you want to calibrate it using [Black-it](https://github.com/bancaditalia/black-it),
you might want to generate a Julia "sysimage" of the project to avoid the overhead
caused by loading Julia libraries and compiling the code every time you run the code.

## Reduce overhead by generating of a sysimage file

First activate the Julia environment

```shell
julia --project=.
```

then run the following three lines

```julia
using PackageCompiler
packages = [:StatsBase]
create_sysimage(packages, sysimage_path="ABCreditjl.so", precompile_execution_file="main.jl")
```

The execution of the last line should a few minutes and will generate
the sysfile named "ABCreditjl.so", with such a file you can run the model
with a lower overhead as

```shell
julia --sysimage ABCreditjl.so main_st_in_out.jl par1 par2 ... par33
```
