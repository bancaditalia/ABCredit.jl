
export initialise_model

"""
    initialise_model(W, F, N; params = ABCredit.PARAMS_ORIGINAL)

Initializes the model with the given parameters.

# Arguments
- `W`: Number of agents in the W dimension.
- `F`: Number of agents in the F dimension.
- `N`: Number of agents in the N dimension.
- `params`: (optional) Dictionary of parameters for the model. Default is `ABCredit.PARAMS_ORIGINAL`.

# Returns
- `model`: The initialized model.

"""
function initialise_model(W, F, N; params = ABCredit.PARAMS_ORIGINAL)

    # set number of agents in the parameters dictionary
    params = copy(params)
    params[:W] = Int(W)
    params[:F] = Int(F)
    params[:N] = Int(N)
    params[:init_price] = 3.0
    params[:init_price_k] = 3.0
    params[:init_K] = 10.0
    params[:maastricht] = false

    workers = ABCredit.initialise_workers(params)

    ### INITIALISE CAPITAL FIRMS AND CONSUMPTION FIRMS ###
    capital_firms, consumption_firms = ABCredit.initialise_firms(params)

    ### INITIALISE BANK AND GOVERNMENT ###
    bank, gov = ABCredit.initialise_bank_gov(params)

    ### INITIALISE SOME AGGREGARE VARIABLES ### 
    agg = ABCredit.initialise_aggregates(params)

    model = Model(params, workers, consumption_firms, capital_firms, bank, gov, agg)

    return model

end


function initialise_model(W::Int, F::Int, N::Int, params::Dict)
    return initialise_model(W, F, N; params = params)
end
