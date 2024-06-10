
export one_model_step!



"""
    one_model_step!(model::AbstractModel)

A complete step of the model simulation.

# Arguments
- `model::AbstractModel`: The model object representing the simulation.

"""
function one_model_step!(model::AbstractModel)

    #################### GET IDS OF AGENTS ####################
    # ids_workers, ids_cons_firms, ids_cap_firms, ids_firms, ids = get_ids(model)

    # ids_workers_rand = copy(ids_workers)
    # ids_cons_firms_rand = copy(ids_cons_firms)

    cons_firms = model.consumption_firms
    cap_firms = model.capital_firms
    workers = model.workers
    gov = model.gov
    bank = model.bank

    # if all the firms are defaulted, then stop simulation
    check_total_bankruptcy(cons_firms)

    reset_gov_and_banking_variables!(model)
    set_bond_interest_rate!(gov, model)

    #################### PRODUCTION DECISIONS ####################
    # firms define expected demands and bid prices
    # note that given search and matching in the demand, the demand
    # perceived by the firms is overestimating actual demand.

    firms_decide_price_quantity!(cons_firms, model)
    firms_decide_price_quantity!(cap_firms, model)

    #################### INVESTMENTS DECISIONS ####################

    firms_decide_investment!(cons_firms, model)

    #################### LABOUR DECISIONS ####################

    firms_decide_labour!(cons_firms, model)
    firms_decide_labour!(cap_firms, model)

    #################### CREDIT MARKET ####################

    firms_get_credit!(cons_firms, model)
    firms_get_credit!(cap_firms, model)

    #################### JOB MARKET ####################

    firms_fire_workers!(cons_firms, model)
    firms_fire_workers!(cap_firms, model)

    # unemployed workers look for a job
    workers_search_job!(workers, model)

    #################### PRODUCTION ####################

    firms_produce!(cons_firms, model)
    firms_produce!(cap_firms, model)

    #################### CAPITAL GOODS MARKET ####################
    # Consumption firms buy the capital they need
    # The capital is bought now and will be used for production in the next
    # period. The capital market is search and matching as the consumption market

    capital_goods_market!(cons_firms, cap_firms, model)

    #################### CONSUPTION GOODS MARKET ####################

    # adjust level of subsidy depending on predicted deficit
    gov_adjusts_subsidy!(gov, model)

    # workers get paid
    workers_get_paid!(workers, model)

    # households (either workers or owners of firms) compute their consumption budget
    households = [workers; cons_firms; cap_firms]
    households_find_cons_budget!(households, model)

    # consumption goods market
    consumption_goods_market!(households, cons_firms, model)


    #################### ACCOUNTING AND BANKRUPTCY ####################

    # accounting for all firms
    firms_accounting!(cons_firms, model)
    firms_accounting!(cap_firms, model)

    # update time series variables (before bankruptcies)
    update_tracking_variables!(model)

    firms_go_bankrupt!(cons_firms, cap_firms, model)

    # bank accounting
    bank_accounting!(bank, model)

    # government accounting
    gov_accounting!(gov, model)

    # if target unemployment is higher, rise wages
    adjust_wages!(model)

    model.agg.timestep += 1

end

######################################
