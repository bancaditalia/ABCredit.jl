
"""
    initialise_bank_gov(params)

Initializes the commercial bank and government objects with the given parameters.

# Arguments
- `params`: A dictionary containing the parameters for initializing the bank and the government.

# Returns
- `bank`: A `Bank` object representing the bank.
- `gov`: A `Government` object representing the government.
"""
function initialise_bank_gov(params)

    ### INITIALISE COMMERCIAL BANK ###
    E_individual = 30.0
    E = E_individual * (params[:F] + params[:N])
    E_threshold = E_individual * (params[:F] + params[:N]) * params[:E_threshold_scale]
    loans = 0.0 # total loans
    profitsB = 0.0 # bank profits
    dividendsB = 0.0 #bank dividends
    reserves = 0.0   # reserves
    deposits = 0.0   # deposits

    bank = Bank(E, E_threshold, loans, profitsB, dividendsB, reserves, deposits)

    ### INITIALISE GOVERNMENT  ###
    G = 0.0 # government spending
    TA = 0.0 # total taxes
    GB = 0.0 # government balance
    EXP = 0.0 # expenditure towards firms
    bonds = 0.0 # bonds
    bond_interest_rate = 0.03 # bond interest rate
    stock_bonds = 0.0 # stock of bonds
    deficitGDP = 0.0 # deficit
    subsidy = params[:subsidy]

    gov = Government(G, TA, GB, EXP, bonds, bond_interest_rate, stock_bonds, deficitGDP, subsidy)

    return bank, gov

end
