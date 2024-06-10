cd(@__DIR__)
println("Loading packages...")
using ABCredit
using Documenter
using Literate

println("Converting Examples...")
cd(@__DIR__)
indir = joinpath("..", "examples")
outdir = joinpath("src", "examples")
rm(outdir; force = true, recursive = true) # cleans up previous examples
mkpath(outdir)

Literate.markdown(joinpath(indir, "basic_example.jl"), outdir; credit = false)
Literate.markdown(joinpath(indir, "compare_histograms.jl"), outdir; credit = false)
Literate.markdown(joinpath(indir, "parallel_evaluations.jl"), outdir; credit = false)

println("Documentation Build")

makedocs(
    sitename = "ABCredit.jl",
    format = Documenter.HTML(prettyurls = false),
    pages = [
        "Home" => "index.md",
        "Essentials" => "examples/basic_example.md",
        "Model and data" => "examples/compare_histograms.md",
        "Parallel evaluations" => "examples/parallel_evaluations.md",
        "Runs from the terminal" => "running_from_the_terminal.md",
        "Code reference" => "api.md",
    ],
)

# deploydocs(;repo = "github.com/bancaditalia/ABCredit.jl.git")
