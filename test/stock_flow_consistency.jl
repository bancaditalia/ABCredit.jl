using ABCredit, Test

@testset "stock flow consistency" begin

    # define the model parameters
    params = ABCredit.PARAMS_GRAZZINI
    W = 1000
    F = 100
    N = 20

    # initialise the model
    model = ABCredit.initialise_model(W, F, N; params)

    # set taxes and subsidies to zero, effectively removing the government
    model.params[:tax_rate] = 0.0
    model.gov.subsidy = 0.0

    init_money = ABCredit.get_tot_money(model)

    # check stock flow consistnecy in each of the 100 time steps
    for n in 1:100
        ABCredit.one_model_step!(model)
        money = ABCredit.get_tot_money(model)
        @test isapprox(init_money, money, atol = 1e-5)
    end

end
