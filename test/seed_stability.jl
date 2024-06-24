using ABCredit
using Random
using Test

params = ABCredit.PARAMS_ORIGINAL

T = 30 # number of epochs
W = 1000 # number of workers
F = 100#Int(round(W / 10.0)) # number of consumption firms
N = 20#Int(round(W / 50.0)) # number of capital firms

# initialise the model


model1 = ABCredit.initialise_model(W, F, N; params)
model2 = ABCredit.initialise_model(W, F, N; params)

# # run the simulation and save data in a CSV
d1 = ABCredit.run_one_sim!(model1, T; seed = 1)
d2 = ABCredit.run_one_sim!(model2, T; seed = 1)

# using Plots 
# plot(d1.inflationRate)
# plot!(d2.inflationRate)

for name in fieldnames(typeof(d1))
    @test getfield(d1, name) == getfield(d2, name)
end
# ABCredit.save_csv(d, "m_df.csv")
