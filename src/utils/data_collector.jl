
export ABCreditData

# define an abstract type for ABCreditData
abstract type AbstractABCreditData end

"""
    mutable struct ABCreditData <: AbstractABCreditData

ABCreditData is a mutable struct to collect the data for the ABCredit model.

# Fields
- `Y_real::Vector{Float64}`: Real GDP values over time.
- `Y_nominal_tot::Vector{Float64}`: Nominal GDP values over time.
- `gdp_deflator::Vector{Float64}`: GDP deflator values over time.
- `inflationRate::Vector{Float64}`: Inflation rate values over time.
- `consumption::Vector{Float64}`: Consumption values over time.
- `wb::Vector{Float64}`: Wage bill values over time.
- `Un::Vector{Float64}`: Unemployment rate values over time.
- `bankruptcy_rate::Vector{Float64}`: Bankruptcy rate values over time.
- `totalDeb::Vector{Float64}`: Total debt values over time.
- `totalDeb_k::Vector{Float64}`: Total debt per capita values over time.
- `Investment::Vector{Float64}`: Investment values over time.
- `totK::Vector{Float64}`: Total capital values over time.
- `inventories::Vector{Float64}`: Inventories values over time.
- `inventories_k::Vector{Float64}`: Inventories per capita values over time.
- `liquidity::Vector{Float64}`: Liquidity values over time.
- `liquidity_k::Vector{Float64}`: Liquidity per capita values over time.
- `E::Vector{Float64}`: Bank equity values over time.
- `dividendsB::Vector{Float64}`: Bank dividends values over time.
- `profitsB::Vector{Float64}`: Bank profits values over time.
- `GB::Vector{Float64}`: Government budget values over time.
- `deficitGDP::Vector{Float64}`: Government deficit as a percentage of GDP values over time.
- `bonds::Vector{Float64}`: Government bonds values over time.
- `loans::Vector{Float64}`: Bank loans values over time.
- `reserves::Vector{Float64}`: Bank reserves values over time.
- `deposits::Vector{Float64}`: Bank deposits values over time.

# Constructors
- `ABCreditData(T::Int64)`: Constructs a ABCreditData object with all fields initialized to zero vectors of length `T + 1`.

"""
mutable struct ABCreditData <: AbstractABCreditData
    #### GDP and inflation ###
    Y_real::Vector{Float64}
    Y_nominal_tot::Vector{Float64}
    gdp_deflator::Vector{Float64}
    inflationRate::Vector{Float64}

    ### consumption, wages, unemployment ###
    consumption::Vector{Float64}
    wb::Vector{Float64}
    Un::Vector{Float64}

    ### investments, debts and bankruptcy ###
    bankruptcy_rate::Vector{Float64}
    totalDeb::Vector{Float64}
    totalDeb_k::Vector{Float64}
    Investment::Vector{Float64}
    totK::Vector{Float64}
    inventories::Vector{Float64}
    inventories_k::Vector{Float64}
    liquidity::Vector{Float64}
    liquidity_k::Vector{Float64}
    leverage::Vector{Float64}
    leverage_k::Vector{Float64}


    ### banking ###
    E::Vector{Float64}
    dividendsB::Vector{Float64}
    profitsB::Vector{Float64}
    GB::Vector{Float64}
    deficitGDP::Vector{Float64}
    bonds::Vector{Float64}
    loans::Vector{Float64}
    reserves::Vector{Float64}
    deposits::Vector{Float64}

    function ABCreditData(T::Int64)
        d = new([zeros(T + 1) for _ in 1:27]...)
        return d
    end
end


function update_basic_data!(d::AbstractABCreditData, model::AbstractModel)
    i = model.agg.timestep

    d.Y_real[i] = model.agg.Y_real
    d.Y_nominal_tot[i] = model.agg.Y_nominal_tot
    d.gdp_deflator[i] = model.agg.gdp_deflator
    d.inflationRate[i] = model.agg.inflationRate
end


function update_worker_data!(d::AbstractABCreditData, model::AbstractModel)
    i = model.agg.timestep

    d.consumption[i] = model.agg.consumption
    d.wb[i] = model.agg.wb
    d.Un[i] = model.agg.Un
end

function update_bank_data!(d::AbstractABCreditData, model::AbstractModel)
    i = model.agg.timestep

    d.E[i] = model.bank.E
    d.dividendsB[i] = model.bank.dividendsB
    d.profitsB[i] = model.bank.profitsB
    d.bankruptcy_rate[i] = model.agg.bankruptcy_rate
    # PAs
    w_PA = sum([worker.PA for worker in model.workers])
    cf_PA = sum([cf.PA for cf in model.consumption_firms])
    capf_PA = sum([capf.PA for capf in model.capital_firms])
    deposits = w_PA + cf_PA + capf_PA
    d.deposits[i] = deposits
    d.reserves[i] = model.bank.E + deposits - model.bank.loans
    d.loans[i] = model.bank.loans
end

function update_firm_data!(d::AbstractABCreditData, model::AbstractModel)
    i = model.agg.timestep

    d.totalDeb[i] = sum(firm.deb for firm in model.consumption_firms) #sum([model[id].deb for id in ids_cons_firms])
    d.totalDeb_k[i] = sum(firm.deb_k for firm in model.capital_firms)
    d.totK[i] = sum(firm.K for firm in model.consumption_firms)

    I = sum(firm.investment for firm in model.consumption_firms)
    inv_var = sum(firm.Y_k - firm.inventory_k for firm in model.capital_firms)
    sum_Y = sum(firm.Y for firm in model.consumption_firms)

    d.Investment[i] = I * model.agg.init_price_k
    d.inventories[i] = sum_Y * model.agg.init_price
    d.inventories_k[i] = inv_var * model.agg.init_price_k

    d.liquidity[i] = sum(firm.liquidity for firm in model.consumption_firms)
    d.liquidity_k[i] = sum(firm.liquidity_k for firm in model.capital_firms)

    d.leverage[i] = sum(firm.lev for firm in model.consumption_firms) 
    d.leverage_k[i] = sum(firm.lev_k for firm in model.capital_firms)
end

function update_gov_data!(d::AbstractABCreditData, model::AbstractModel)
    i = model.agg.timestep
    d.GB[i] = model.gov.GB
    d.deficitGDP[i] = model.gov.deficitGDP
    d.bonds[i] = model.gov.bonds
end

"""
Update the d object with data from timestep i
"""


"""
    update_data!(model::AbstractModel, d::AbstractABCreditData, i::Int64)

Update the data object with the information provided in the model object.

# Arguments
- `model::AbstractModel`: The model to update the data for.
- `d::AbstractABCreditData`: The ABCredit data to use for updating.

"""
function update_data!(d::AbstractABCreditData, model::AbstractModel)
    update_basic_data!(d, model)
    update_worker_data!(d, model)
    update_bank_data!(d, model)
    update_firm_data!(d, model)
    update_gov_data!(d, model)
end


"""
    save_csv(d::ABCreditData, csv_name::AbstractString)

Save the data from the `ABCreditData` object to a CSV file with the given name.

# Arguments
- `d::ABCreditData`: The `ABCreditData` object containing the data to be saved.
- `csv_name::AbstractString`: The name of the CSV file to be created.

"""
function save_csv(d::AbstractABCreditData, csv_name::AbstractString)
    # define a CSV
    df = DataFrame()

    for name in fieldnames(typeof(d))
        insertcols!(df, name => getfield(d, name))
    end

    CSV.write(csv_name, df)
end


function load_csv(csv_name::AbstractString)
    df = CSV.read(csv_name, DataFrame)
    d = ABCredit.ABCreditData(1)
    for name in fieldnames(typeof(d))
        setfield!(d, name, df[!, name])
    end
    return d
end


struct DataVector
    vector::Vector{AbstractABCreditData}
end

# Define the getproperty function for the DataVector struct
# This function allows for the extraction of fields from the Data struct
# by using the dot syntax
function Base.getproperty(dv::DataVector, name::Symbol)
    if name in fieldnames(ABCreditData)
        # If the field name exists in the `a` struct, extract it from all elements
        return hcat([getproperty(d, name) for d in dv.vector]...)
    else
        # Fallback to default behavior for other fields
        return getfield(dv, name)
    end
end
