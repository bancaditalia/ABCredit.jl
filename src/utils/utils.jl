"""
Compute total money in the system
"""
function get_tot_money(model::AbstractModel)

    workers = model.workers
    cons_firms = model.consumption_firms
    cap_firms = model.capital_firms
    bank = model.bank
    gov = model.gov

    w_PA = sum([worker.PA for worker in workers])
    cf_PA = sum([firm.PA for firm in cons_firms])
    capf_PA = sum([firm.PA for firm in cap_firms])

    sum_PA = w_PA + cf_PA + capf_PA

    sum_liquidity = sum([firm.liquidity for firm in cons_firms])

    sum_liquidity_k = sum([firm.liquidity_k for firm in cap_firms])

    money = sum_PA + sum_liquidity + sum_liquidity_k + bank.E - bank.loans - gov.stock_bonds
    # println("\n")
    # println("money: ", money)
    # println("sum_PA: ", sum_PA)
    # println("sum_liquidity: ", sum_liquidity)
    # println("sum_liquidity_k: ", sum_liquidity_k)
    # println("E: ", model.bank.E)
    # println("loans: ", model.bank.loans)
    # println("stock_bonds: ", model.gov.stock_bonds)

    return money
end


"""
Adjust worker wages depending on unemployment level relative to target
"""
function adjust_wages!(model::AbstractModel)
    # if target unemployment is higher, rise wages
    if model.params[:u_target] - model.agg.Un > 0
        model.agg.wb = model.agg.wb * (1 + model.params[:wage_update_up] * (model.params[:u_target] - model.agg.Un))
        # if target unemployment is lower, lower wages
    else
        model.agg.wb = model.agg.wb * (1 + model.params[:wage_update_down] * (model.params[:u_target] - model.agg.Un))
    end
end


"""
End simulation if all consumption firms are bankrupt
"""
function check_total_bankruptcy(cons_firms::Vector{<:AbstractConsumptionFirm})
    if sum([firm.A for firm in cons_firms]) == 0
        error("All firms are bankrupt")
    end
end
