
"""
    firm_accounting!(firm::AbstractConsumptionFirm, model::AbstractModel)

Perform accounting operations for a consumption firm in a given model.

# Arguments
- `firm::AbstractConsumptionFirm`: The firm for which accounting operations are performed.
- `model::AbstractModel`: The model in which the firm operates.

# Description
This function updates the firm's liquidity, loans, profits, income, dividends, and assets based on the given model parameters.

"""
function firm_accounting!(firm::AbstractConsumptionFirm, model::AbstractModel)
    #capital capacity update
    firm.barYK = model.params[:delta] * firm.barYK + (1 - model.params[:delta]) * firm.Y_prev / model.params[:k]

    #capital depreciation
    dep = model.params[:eta] * firm.Y_prev / model.params[:k] #only the used capital is depreciating

    #capital reduced by depreciation
    firm.K -= dep

    #capital increased by bought capital
    firm.K += firm.investment

    #update capital value in the book
    depreciation_value = dep * firm.capital_value / (firm.K + dep - firm.investment)
    firm.capital_value = firm.capital_value - depreciation_value + firm.value_investments

    #firm revenues
    RIC = firm.P * firm.Q

    firm.liquidity = firm.liquidity - firm.interests - model.params[:theta] * firm.deb
    model.bank.E += firm.interests
    model.bank.profitsB += firm.interests

    #loans are updated (the installments have been paid)
    model.bank.loans -= firm.deb * model.params[:theta]
    firm.deb = (1 - model.params[:theta]) * firm.deb

    #consumption firm profits
    profits = RIC - firm.wages - firm.interests - depreciation_value

    #equity law of motion!
    firm.A = firm.A + profits

    # update dividends income for owner of firm
    firm.income = 0
    #pick firms with positive profits
    if profits > 0
        di = model.params[:div] * profits  ##dividends     #compute dividends paid by firm i
        divi = di * (1 - model.params[:tax_rate_d])  #dividends after taxes
        model.gov.TA += di * model.params[:tax_rate_d] # taxes on dividends are collected
        firm.PA += divi          #dividends paid to firm owner
        firm.income = divi
        firm.liquidity -= di
        firm.A -= di
        model.agg.dividends += di  #lordi
        #TODO: this following line has no effect on the rest of the code!
        # profits -= divi
    end
end



"""
    firm_accounting!(firm::AbstractCapitalFirm, model::AbstractModel)

Perform accounting operations for a capital firm in a given model.

# Arguments
- `firm::AbstractCapitalFirm`: The firm for which accounting operations are performed.
- `model::AbstractModel`: The model in which the firm operates.

# Description
This function updates the firm's liquidity, loans, profits, income, dividends, and assets based on the given model parameters.

"""
function firm_accounting!(firm::AbstractCapitalFirm, model::AbstractModel)
    RIC_k = firm.P_k * firm.Q_k

    firm.liquidity_k = firm.liquidity_k - firm.interests_k - model.params[:theta] * firm.deb_k
    model.bank.E += firm.interests_k
    model.bank.profitsB += firm.interests_k

    #update loans
    model.bank.loans -= firm.deb_k * model.params[:theta]
    firm.deb_k = (1 - model.params[:theta]) * firm.deb_k

    #profits
    profits_k = RIC_k - firm.wages_k - firm.interests_k


    firm.income = 0
    #pick firms with positive profits
    if profits_k > 0
        di = model.params[:div] * profits_k
        divi = di * (1 - model.params[:tax_rate_d]) #dividends after taxes
        model.gov.TA += di * model.params[:tax_rate_d] # taxes on dividends are collected
        firm.PA += divi  #dividends paid to firm i owner
        firm.income = divi
        firm.liquidity_k -= di
        model.agg.dividends += di
        # profits_k -= divi
    end
    # update assets
    firm.A_k = firm.liquidity_k + firm.Y_k * model.agg.price_k - firm.deb_k
end



"""
    firms_accounting!(firms, model)

Perform accounting operations for a collection of firms.

This function iterates over a collection of firms and calls the `firm_accounting!` function for each firm.

# Arguments
- `firms`: A vector of either `AbstractCapitalFirm` or `AbstractConsumptionFirm` objects.
- `model`: An `AbstractModel` object.

"""
function firms_accounting!(
    firms::Union{Vector{<:AbstractCapitalFirm}, Vector{<:AbstractConsumptionFirm}},
    model::AbstractModel,
)
    for firm in firms
        firm_accounting!(firm, model)
    end
end
