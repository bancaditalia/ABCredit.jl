using ABCredit, Test

@testset "consumption goods market" begin

    params = ABCredit.PARAMS_ORIGINAL

    params[:k] = 0.1
    params[:z_c] = 2

    W = 10
    F = 2
    N = 2

    # initialise the model
    model = ABCredit.initialise_model(W, F, N; params)

    #### CASE 1: consumer does not spend all money ####
    consumer = model.workers[1]
    consumer.PA = 2.0
    consumer.cons_budget = 1.0

    cons_firms = model.consumption_firms

    for firm in cons_firms
        firm.P = 0.25 # price
        firm.Y = 1.0 # quantity

        firm.Q = 0  #reset sales to zero
        firm.Yd = 0 #record demand
    end

    ABCredit.consumption_goods_market!(consumer, cons_firms, model)

    @test consumer.PA == 2.0 - 0.25 * F
    @test consumer.cons_budget == 1.0 - 0.25 * F

    endY = [firm.Y for firm in cons_firms]
    endQ = [firm.Q for firm in cons_firms]
    endYd = [firm.Yd for firm in cons_firms]

    @test endY == [0, 0]
    @test endQ == [1, 1]
    @test endYd == [1 / 0.25, 0.75 / 0.25] # first firm and second visit

    #### CASE 2: consumer does not spend all money ####
    consumer.PA = 2.0
    consumer.cons_budget = 2.0

    for firm in cons_firms
        firm.P = 5.0 # price
        firm.Y = 1.0 # quantity

        firm.Q = 0  #reset sales to zero
        firm.Yd = 0 #record demand
    end

    ABCredit.consumption_goods_market!(consumer, cons_firms, model)

    @test consumer.PA == 0.0
    @test consumer.cons_budget == 0.0

    endY = [firm.Y for firm in cons_firms]
    endQ = [firm.Q for firm in cons_firms]
    endYd = [firm.Yd for firm in cons_firms]

    @test endY == [1.0 - 2.0 / 5.0, 1.0]
    @test endQ == [2.0 / 5.0, 0.0]
    @test endYd == [2 / 5, 0]

end
