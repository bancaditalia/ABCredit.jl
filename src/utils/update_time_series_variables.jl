"""
Compute new retail price index
"""
function update_price!(model::AbstractModel, cons_firms::Vector{<:AbstractConsumptionFirm})

    #inflation rate
    tot_Q = sum([firm.Q for firm in cons_firms])

    #retail price index
    RPI = 0.0
    if tot_Q > 0
        for firm in cons_firms
            RPI = RPI + firm.Q * firm.P
        end
        RPI = RPI / tot_Q
    else
        for firm in cons_firms
            RPI = RPI + firm.P / model.agg.F
        end
    end

    model.agg.inflationRate = RPI / model.agg.price - 1
    model.agg.price = RPI

end

"""
Compute new capital price index
"""
function update_price_k!(model::AbstractModel, cap_firms::Vector{<:AbstractCapitalFirm})

    # update capital price index via a weighted average of prices
    tot_Q_k = sum([firm.Q_k for firm in cap_firms])

    model.agg.price_k = 0
    if tot_Q_k > 0
        for firm in cap_firms
            model.agg.price_k += firm.Q_k * firm.P_k
        end
        model.agg.price_k = model.agg.price_k / tot_Q_k
    else
        for firm in cap_firms
            model.agg.price_k += firm.P_k / model.params[:N]
        end
    end

end

"""
Compute some aggregate economic indicators
"""
function update_tracking_variables!(model::AbstractModel)

    cons_firms = model.consumption_firms
    cap_firms = model.capital_firms
    workers = model.workers

    update_price!(model, cons_firms)
    update_price_k!(model, cap_firms)

    # Compute the bankruptcy rate
    negcash_k = sum([firm.A_k <= 0 for firm in cap_firms])
    negcash = sum([firm.A <= 0 for firm in cons_firms])

    #number of firms with different leverages
    model.agg.bankruptcy_rate = (negcash_k + negcash) / (model.params[:F] + model.params[:N])

    model.agg.Un = sum([worker.Oc == 0 for worker in workers]) / model.params[:W]

    tot_Y_c = sum([firm.Y_prev for firm in cons_firms])
    tot_Y_k = sum([firm.Y_prev_k for firm in cap_firms])
    Y_nominal_c = tot_Y_c * model.agg.price
    Y_nominal_k = tot_Y_k * model.agg.price_k
    model.agg.Y_nominal_tot = Y_nominal_c + Y_nominal_k
    model.agg.Y_real = tot_Y_c * model.agg.init_price + tot_Y_k * model.agg.init_price_k
    model.agg.gdp_deflator = model.agg.Y_nominal_tot / model.agg.Y_real

end

"""
Reset some government and banking variables to zero before after every epoch
"""
function reset_gov_and_banking_variables!(model::AbstractModel)

    model.agg.dividends = 0.0
    model.agg.defaults = 0

    model.bank.profitsB = 0.0 #reset bank's profits
    model.bank.reserves = 0.0

    model.gov.TA = 0 #reset government revenues and expenditure
    model.gov.G = 0 
    model.gov.GB = 0.0
    model.gov.EXP = 0.0

end

"""
Reset some variables to zero before the capital-goods market
"""
function reset_variables_capital_market(
    model::AbstractModel,
    cons_firms::Vector{<:AbstractConsumptionFirm},
    cap_firms::Vector{<:AbstractCapitalFirm},
)

    for firm in cons_firms
        firm.investment = 0
        firm.value_investments = 0
    end

    for firm in cap_firms
        firm.Q_k = 0  # reset sales to zero for cap firms
        firm.Y_kd = 0  # record demand
    end

end

"""
Reset some variables to zero before the consumption-goods market
"""
function reset_variables_consumption_market(model::AbstractModel, cons_firms::Vector{<:AbstractConsumptionFirm})

    model.agg.con = 0.0 # reinitialise the consumption to zero for this epoc

    for firm in cons_firms
        firm.Q = 0  #reset sales to zero for prod firms
        firm.Yd = 0 #record demand
    end

end
