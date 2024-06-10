using ABCredit
using Test
using CSV
using DataFrames

# define the model parameters
params = ABCredit.PARAMS_GRAZZINI

dir = @__DIR__

W = 200
F = 20
N = 4

# initialise the model
model = ABCredit.initialise_model(W, F, N; params)

T = 30
seed = 1
d = ABCredit.run_one_sim!(model, T; seed = seed);

# ABCredit.save_csv(d, dir*"/fixtures/data_fixed_seed_$seed.csv")

data_expected = ABCredit.load_csv( dir*"/fixtures/data_fixed_seed_$seed.csv")

for name in fieldnames(typeof(d))
    @test isapprox(getfield(d, name), getfield(data_expected, name), rtol = 1e-2)
end

