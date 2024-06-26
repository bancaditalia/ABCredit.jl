
"""
    initialise_aggregates(params)

Initializes the aggregate variables used in the model.

# Arguments
- `params`: A dictionary containing the model parameters.

# Returns
- `agg`: An instance of the `Aggregates` struct.
"""
function initialise_aggregates(params)

    ### INITIALISE SOME AGGREGARE VARIABLES ### 
    consumption = 0.0  #total cunsumption evaluated at the initial price
    con = 0.0         #total consumption quantities
    init_price = params[:init_price]    #initial price
    price = params[:init_price]         #consumer price index
    init_price_k = params[:init_price_k]
    price_k = params[:init_price_k]
    Un = 0.0          #unemployment 
    dividends = 0.0     #total dividends
    credit_mismatch = 0.0
    barK = params[:init_K] #average capital by firms
    defaults = 0   #number of bankruptcies
    defaults_k = 0
    inflationRate = 0.0
    Y_nominal_tot = 0.0
    Y_real = 0.0
    gdp_deflator = 0.0
    bankruptcy_rate = 0.0
    totK = 0.0
    timestep = 1
    wb = params[:wb]

    agg = Aggregates(
        consumption,
        con,
        init_price,
        price,
        init_price_k,
        price_k,
        Un,
        dividends,
        credit_mismatch,
        barK,
        defaults,
        defaults_k,
        inflationRate,
        Y_nominal_tot,
        Y_real,
        gdp_deflator,
        bankruptcy_rate,
        totK,
        timestep,
        wb,
    )

    return agg

end
