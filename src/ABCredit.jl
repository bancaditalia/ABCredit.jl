module ABCredit

using Statistics
using Random
using StatsBase
using DelimitedFiles
using DataFrames
using CSV

# definition of agents
include("model_init/agents.jl")

# model initialisation function
include("model_init/init.jl")
include("model_init/init_workers.jl")
include("model_init/init_bank_gov.jl")
include("model_init/init_firms.jl")
include("model_init/init_agg.jl")

# step functions for the agents and their interactions
include("agent_actions/firms_price_quantity.jl")
include("agent_actions/firms_investment_labour.jl")
include("agent_actions/firms_production.jl")
include("agent_actions/worker_gets_paid.jl")
include("agent_actions/firms_bankruptcy.jl")
include("agent_actions/government.jl")
include("agent_actions/firms_accounting.jl")
include("agent_actions/bank_accounting.jl")

# markets
include("markets/credit_market.jl")
include("markets/job_market.jl")
include("markets/capital_goods_market.jl")
include("markets/consumption_goods_market.jl")

# others
include("utils/update_time_series_variables.jl")
include("utils/utils.jl")
include("utils/data_collector.jl")

#standard parametrisations
include("params/standard_params.jl")

# a complete step
include("one_step.jl")
include("one_simulation.jl")

end
