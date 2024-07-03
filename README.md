<div align='center'>
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/bancaditalia/ABCredit.jl/main/docs/logo/logo_white_text.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/bancaditalia/ABCredit.jl/main/docs/logo/logo_black_text.png">
  <img alt="Logo adapts to light and dark modes" src="https://raw.githubusercontent.com/bancaditalia/ABCredit.jl/main/docs/logo/logo_black_text.png" width="500">
</picture>
<sup><a href="#footnote-1">*</a></sup>
</div>

# The ABC of macroeconomic agent-based modelling

A fast and easy to use Julia implementation of the model described in [_Emergent dynamics of a macroeconomic agent based model with capital and credit_](https://www.sciencedirect.com/science/article/abs/pii/S0165188914001572).
The package can be used to simulate the original model or as a base for extensions. If you are not familiar with Julia and the way in which multiple dispatch allows for powerful extensions, don't hesitate to get in touch!

## Installation

```julia
using Pkg
Pkg.add("ABCredit")
```

## Quick example

```julia
using ABCredit

W = 1000 # number of workers
F = 100  # number of consumption firms
N = 20   # number of capital firms

model = ABCredit.initialise_model(W, F, N)

T = 1000 # number of epochs

d = ABCredit.run_one_sim!(model, T)
```

To plot the results of the simulation, install the `Plots` package via ```Pkg.add("Plots")```  and then run

```julia
using Plots

plot(d.Y_real)
```

## Citing _ABCredit_

If you found this package useful for your research, please cite the following publication

```bib
@inproceedings{glielmo2023reinforcement,
  title={Reinforcement Learning for Combining Search Methods in the Calibration of Economic ABMs},
  author={Aldo Glielmo and Marco Favorito and Debmallya Chanda and Domenico Delli Gatti},
  booktitle={Proceedings of the Fourth ACM International Conference on AI in Finance},
  pages={305--313},
  year={2023}
}
```

## Disclaimer

This package is an outcome of a research project. All errors are those of
the authors. All views expressed are personal views, not those of Bank of Italy.

<p id="footnote-1">
* Credits to <a href="https://www.bankit.art/people/sara-corbo">Sara Corbo</a>  for the logo, echoing the logo of <a href="https://github.com/bancaditalia/BeforeIT.jl">BeforeIT</a> but with warmer colors.
</p>
