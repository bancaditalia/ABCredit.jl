using ABCredit, Test

@testset "stock flow consistency detailed epoch" begin
    # define the model parameters
    params = ABCredit.PARAMS_ORIGINAL

    T = 10
    W = 10000
    F = 1000
    N = 20

    # initialise the model
    model = ABCredit.initialise_model(W, F, N; params)

    d = ABCredit.ABCreditData(T)

    # store variables at initialisation
    ABCredit.update_data!(d, model)

    model.params[:tax_rate] = 0.0
    model.gov.subsidy = 0.0
    model.params[:z_c] = 2 # hard code number of neighbouring firms to one for the test
    # model.z_e = 1 # hard code number of neighbouring firms to one for the test
    # model.z_k = 1 # hard code number of neighbouring firms to one for the test

    # save the ids as properties

    init_money = ABCredit.get_tot_money(model)
    # println("init money ", init_money)

    cons_firms = model.consumption_firms
    cap_firms = model.capital_firms
    workers = model.workers
    gov = model.gov
    bank = model.bank
    agg = model.agg

    for i in 2:(T + 1)
        # println("t: ", i)

        ABCredit.check_total_bankruptcy(cons_firms)
        money = ABCredit.get_tot_money(model)
        # println("money 0: ", money)
        @test isapprox(init_money, money, atol = 1e-5)


        ABCredit.reset_gov_and_banking_variables!(model)
        ABCredit.set_bond_interest_rate!(gov, model)
        money = ABCredit.get_tot_money(model)
        # println("money 1: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        #################### PRODUCTION DECISIONS ####################
        ABCredit.firms_decide_price_quantity!(cons_firms, model)
        ABCredit.firms_decide_price_quantity!(cap_firms, model)
        money = ABCredit.get_tot_money(model)
        # println("money 2: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        #################### INVESTMENTS DECISIONS ####################
        ABCredit.firms_decide_investment!(cons_firms, model)
        # println("money 3: ", ABCredit.get_tot_money(model))

        #################### LABOUR DECISIONS ####################
        ABCredit.firms_decide_labour!(cons_firms, model)
        ABCredit.firms_decide_labour!(cap_firms, model)
        # println("money 4: ", ABCredit.get_tot_money(model))

        #################### CREDIT MARKET ####################
        ABCredit.firms_get_credit!(cons_firms, model)
        ABCredit.firms_get_credit!(cap_firms, model)
        # println("money 5: ", ABCredit.get_tot_money(model))

        #################### JOB MARKET ####################
        ABCredit.firms_fire_workers!(cons_firms, model)
        ABCredit.firms_fire_workers!(cap_firms, model)
        # println("money 6: ", ABCredit.get_tot_money(model))

        # unemployed workers look for a job
        ABCredit.workers_search_job!(workers, model)
        # println("money 7: ", ABCredit.get_tot_money(model))

        #################### PRODUCTION ####################
        ABCredit.firms_produce!(cons_firms, model)
        ABCredit.firms_produce!(cap_firms, model)
        # println("money 8: ", ABCredit.get_tot_money(model))

        #################### CAPITAL GOODS MARKET ####################
        ABCredit.capital_goods_market!(cons_firms, cap_firms, model)
        # println("money 9: ", ABCredit.get_tot_money(model))

        #################### CONSUPTION GOODS MARKET ####################

        # adjust level of subsidy depending on predicted deficit
        ABCredit.gov_adjusts_subsidy!(gov, model)
        money = ABCredit.get_tot_money(model)
        # println("money 10: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # workers get paid
        ABCredit.workers_get_paid!(workers, model)
        money = ABCredit.get_tot_money(model)
        # println("money 11: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # households_find_cons_budget! compute their consumption budget
        households = [workers; cons_firms; cap_firms]
        ABCredit.households_find_cons_budget!(households, model)
        money = ABCredit.get_tot_money(model)
        # println("money 12: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # consumption goods market
        ABCredit.consumption_goods_market!(households, cons_firms, model)
        money = ABCredit.get_tot_money(model)
        # println("money 13: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        #################### ACCOUNTING AND BANKRUPTCY ####################

        # accounting for all firms
        ABCredit.firms_accounting!(cons_firms, model)
        ABCredit.firms_accounting!(cap_firms, model)
        money = ABCredit.get_tot_money(model)
        # println("money 14: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # update time series variables (before bankruptcies)
        ABCredit.update_tracking_variables!(model)
        ABCredit.firms_go_bankrupt!(cons_firms, cap_firms, model)
        money = ABCredit.get_tot_money(model)
        # println("money 16: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # bank accounting
        ABCredit.bank_accounting!(bank, model)
        money = ABCredit.get_tot_money(model)
        # println("money 17: ", money)
        @test isapprox(init_money, money, atol = 1e-5)

        # government accounting
        ABCredit.gov_accounting!(gov, model)
        # println("money 18: ", ABCredit.get_tot_money(model))

        # if target unemployment is higher, rise wages
        ABCredit.adjust_wages!(model)
        # println("money 19: ", ABCredit.get_tot_money(model))

        ABCredit.update_data!(d, model)
        money = ABCredit.get_tot_money(model)
        # println("money 20: ", money)

    end

end
