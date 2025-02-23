```@meta
CurrentModule = ABCredit 
```

# ABCredit.jl

A fast, and simple to use, Julia implementation of the model in _Emergent dynamics of a macroeconomic agent based model with capital and credit_, Assenza et al. (2017).

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

To plot the time series within the `d` object, make sure you install `Plots.jl` in the same environment using

```julia
Pkg.add("Plots")
```

and then try running

```julia
using Plots

plot(data.Y_real)
```

## Original author

- [Aldo Glielmo](https://github.com/AldoGl) <[aldo.glielmo@bancaditalia.it](mailto:aldo.glielmo@bancaditalia.it)>

## Other collaborators for the project

- [Simone Brusatin](https://github.com/Brusa99)
- [Debmallya Chanda](https://github.com/Debchanda93)
- [Marco Favorito](https://github.com/marcofavorito)
- [Domenico Delli Gatti](https://docenti.unicatt.it/ppd2/en/docenti/03684/domenico-delli-gatti/profilo)
- [Marco Benedetti](https://www.bankit.art/people/marco-benedetti)

## Citing _ABCredit_

If you found this package useful for your research, please cite (one of) the following publication(s): the research works that made it possible to develop and release _ABCredit.jl_.

In this work, we extend _ABCredit.jl_ with reinforcement learning agents:
```bib
@inproceedings{brusatin2024simulating,
  title={Simulating the economic impact of rationality through reinforcement learning and agent-based modelling},
  author={Brusatin, Simone and Padoan, Tommaso and Coletta, Andrea and Delli Gatti, Domenico and Glielmo, Aldo},
  booktitle={Proceedings of the 5th ACM International Conference on AI in Finance},
  pages={159--167},
  year={2024}
}
```

In this work, we calibrate _ABCredit.jl_ efficiently using reinforcement learning to select search methods (the calibration code is [here](https://github.com/bancaditalia/black-it/blob/main/examples/RL_to_combine_search_methods.ipynb)):
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
