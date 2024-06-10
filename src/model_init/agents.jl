
export Worker, FirmProduction, FirmCapital, Bank, Government, Aggregates, Model

# define an abstract type for workers and firms
abstract type AbstractAgent end
abstract type AbstractWorker <: AbstractAgent end
abstract type AbstractFirm <: AbstractAgent end
abstract type AbstractCapitalFirm <: AbstractFirm end
abstract type AbstractConsumptionFirm <: AbstractFirm end
abstract type AbstractBank end
abstract type AbstractGovernment end
abstract type AbstractModel end


"""
    mutable struct Worker <: AbstractWorker

A Worker type. 

# Fields
- `w::Float64`: earned wages
- `PA::Float64`: household personal assets (saving stock)
- `Oc::Int64`: employment status: Oc(i)=j --> worker j employed by firm i; if i=0, j is unemployed
- `income::Float64`: generic income, it can be wages or subsidy
- `cons_budget::Float64`: consumption budget
- `permanent_income::Float64`: time-averaged income
"""
mutable struct Worker <: AbstractWorker
    w::Float64
    PA::Float64
    Oc::Int64
    income::Float64
    cons_budget::Float64
    permanent_income::Float64
end

"""
    mutable struct FirmProduction <: AbstractConsumptionFirm

A FirmProduction type.

# Fields
- `firm_id::Int64`: firm id, needed for the job market
- `value_investments::Float64`: investments in the firm
- `investment::Float64`: physical capital acquired in the period
- `K::Float64`: physical capital
- `A::Float64`: firm equity
- `liquidity::Float64`: firm liquid resources
- `capital_value::Float64`: capital value
- `P::Float64`: prices
- `Y_prev::Float64`: past production
- `Yd::Float64`: target quantity demanded
- `Q::Float64`: actual sales
- `Leff::Float64`: current employees
- `De::Float64`: expected demand
- `deb::Float64`: firm debts
- `barK::Float64`: 
- `barYK::Float64`: 
- `x::Float64`: 
- `interest_r::Float64`: interest rate on loans
- `interests::Float64`: interests paid
- `Ftot::Float64`: total borrowings
- `K_dem::Float64`: demanded capital
- `K_des::Float64`: desired capital
- `Ld::Int64`: demanded labour
- `B::Float64`: financial gap
- `lev::Float64`: leverage
- `vacancies::Int64`: number of vacancies
- `Y::Float64`: production
- `wages::Float64`: wages paid
- `stock::Float64`: stock of goods
- `income::Float64`: the income provided to the owner of the firm
- `PA::Float64`: the PA of the owner of the firm
- `cons_budget::Float64`: consumption budget of the owner of the firm
- `permanent_income::Float64`: time-averaged income
"""
mutable struct FirmProduction <: AbstractConsumptionFirm
    firm_id::Int64
    value_investments::Float64
    investment::Float64
    K::Float64
    A::Float64
    liquidity::Float64
    capital_value::Float64
    P::Float64
    Y_prev::Float64
    Yd::Float64
    Q::Float64
    Leff::Float64
    De::Float64
    deb::Float64
    barK::Float64
    barYK::Float64
    x::Float64
    interest_r::Float64
    interests::Float64
    Ftot::Float64
    K_dem::Float64
    K_des::Float64
    Ld::Int64
    B::Float64
    lev::Float64
    vacancies::Int64
    Y::Float64
    wages::Float64
    stock::Float64
    income::Float64
    PA::Float64
    cons_budget::Float64
    permanent_income::Float64
end


"""
    mutable struct FirmCapital <: AbstractCapitalFirm

A mutable struct representing a firm's capital.

# Fields:
- `firm_id::Int64`: firm id, needed for the job market
- `Leff_k::Float64`: current employees
- `Y_k::Float64`: production
- `Y_prev_k::Float64`: past production
- `Y_kd::Float64`: target quantity demanded
- `P_k::Float64`: prices
- `A_k::Float64`: firm equity
- `liquidity_k::Float64`: firm liquid resources
- `De_k::Float64`: expected demand
- `deb_k::Float64`: firm debts
- `Q_k::Float64`: actual sales
- `Ftot_k::Float64`: total borrowings
- `interest_r_k::Float64`: interest rate on loans
- `interests_k::Float64`: interests paid
- `Ld_k::Int64`: demanded labour
- `B_k::Float64`: financial gap
- `lev_k::Float64`: leverage
- `vacancies_k::Int64`: number of vacancies
- `inventory_k::Float64`: stock of goods
- `wages_k::Float64`: wages paid
- `stock_k::Float64`: stock of goods
- `income::Float64`: the income provided to the owner of the firm
- `PA::Float64`: the PA of the owner of the firm
- `cons_budget::Float64`: consumption budget of the owner of the firm
- `permanent_income::Float64`: time-averaged income
"""
mutable struct FirmCapital <: AbstractCapitalFirm
    firm_id::Int64
    Leff_k::Float64
    Y_k::Float64
    Y_prev_k::Float64
    Y_kd::Float64
    P_k::Float64
    A_k::Float64
    liquidity_k::Float64
    De_k::Float64
    deb_k::Float64
    Q_k::Float64
    Ftot_k::Float64
    interest_r_k::Float64
    interests_k::Float64
    Ld_k::Int64
    B_k::Float64
    lev_k::Float64
    vacancies_k::Int64
    inventory_k::Float64
    wages_k::Float64
    stock_k::Float64
    ######################## ATTRIBUTES OF FIRM'S OWNER
    income::Float64
    PA::Float64
    cons_budget::Float64
    permanent_income::Float64
end

"""
    mutable struct Bank <: AbstractBank

A mutable struct representing a bank.

# Fields:
- `E::Float64`: equity
- `E_threshold::Float64`: equity threshold
- `loans::Float64`: loans
- `profitsB::Float64`: profits
- `dividendsB::Float64`: dividends
- `reserves::Float64`: reserves
- `deposits::Float64`: deposits
"""
mutable struct Bank <: AbstractBank
    E::Float64
    E_threshold::Float64
    loans::Float64
    profitsB::Float64
    dividendsB::Float64
    reserves::Float64
    deposits::Float64
end


"""
    mutable struct Government <: AbstractGovernment

The `Government` struct represents a government entity in the model.

# Fields:
- `G::Float64 `: government spending in subsidies
- `TA::Float64 `: total taxes
- `GB::Float64`: government balance
- `EXP::Float64`: expenditure towards firms
- `bonds::Float64`: bonds
- `bond_interest_rate::Float64`: bond interest rate
- `stock_bonds::Float64`: stock of bonds
- `deficitGDP::Float64`: deficit
- `subsidy::Float64`: subsidy
"""
mutable struct Government <: AbstractGovernment
    G::Float64
    TA::Float64
    GB::Float64
    EXP::Float64
    bonds::Float64
    bond_interest_rate::Float64
    stock_bonds::Float64
    deficitGDP::Float64
    subsidy::Float64
end



"""
    mutable struct Aggregates

A mutable struct representing the aggregates in the model.

# Fields:
- `consumption::Float64`: consumption in nominal price
- `con::Float64`: consumption in quantity
- `init_price::Float64`: initial price
- `price::Float64`: price
- `init_price_k::Float64`: initial price of capital goods
- `price_k::Float64`: average price of capital goods
- `Un::Float64`: unemployment
- `dividends::Float64`: dividends
- `credit_mismatch::Float64`: credit mismatch
- `barK::Float64`: barK
- `defaults::Float64`: defaults
- `defaults_k::Float64`: defaults of capital
- `inflationRate::Float64`: inflation rate
- `Y_nominal_tot::Float64`: total nominal output
- `Y_real::Float64`: total real output
- `gdp_deflator::Float64`: GDP deflator
- `bankruptcy_rate::Float64`: bankruptcy rate
- `totK::Float64`: total capital
- `timestep::Int64`: time step
- `wb::Float64`: wage bill
"""
mutable struct Aggregates
    consumption::Float64
    con::Float64
    init_price::Float64
    price::Float64
    init_price_k::Float64
    price_k::Float64
    Un::Float64
    dividends::Float64
    credit_mismatch::Float64
    barK::Float64
    defaults::Float64
    defaults_k::Float64
    inflationRate::Float64
    Y_nominal_tot::Float64
    Y_real::Float64
    gdp_deflator::Float64
    bankruptcy_rate::Float64
    totK::Float64
    timestep::Int64
    wb::Float64
end


"""
    struct Model <: AbstractModel

The `Model` struct represents the entire model.

# Fields:
- `params::Dict{Symbol, Any}`: A dictionary that stores various parameters used in the model.
- `workers::Vector{Worker}`: A vector of `Worker` objects representing the workers in the model.
- `consumption_firms::Vector{FirmProduction}`: A vector of `FirmProduction` objects representing the consumption firms in the model.
- `capital_firms::Vector{FirmCapital}`: A vector of `FirmCapital` objects representing the capital firms in the model.
- `bank::Bank`: An object representing the bank in the model.
- `gov::Government`: An object representing the government in the model.
- `agg::Aggregates`: An object representing the aggregate variables in the model.
"""
mutable struct Model <: AbstractModel
    params::Dict{Symbol, Any}
    workers::Vector{Worker}
    consumption_firms::Vector{FirmProduction}
    capital_firms::Vector{FirmCapital}
    bank::Bank
    gov::Government
    agg::Aggregates
end
