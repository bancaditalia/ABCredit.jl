```@meta
CurrentModule = ABCredit 
```

```@contents
Pages = ["api.md"]
```

# Code reference

In this page we document the functions which constitute the bulk of ABCredit.jl functionality.

## Agent types

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["agents.jl"]
```

## Initialisation function

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["init.jl"]
```

## Functions to run an entire simulation

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["one_simulation.jl"]
```

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["one_step.jl"]
```

## Firms actions

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["firm_investment.jl", "firms_expected_demand.jl", "production.jl"]
```

```@docs
ABCredit.firm_accounting!(firm::AbstractConsumptionFirm, model::AbstractModel)
ABCredit.firm_accounting!(firm::AbstractCapitalFirm, model::AbstractModel)
```

## Workers actions

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["worker_gets_paid.jl"]
```

## Bank actions

```@docs
ABCredit.bank_accounting!
```

## Government actions

```@autodocs
Modules = [ABCredit]
Order   = [:type, :function]
Pages   = ["government.jl"]
```
