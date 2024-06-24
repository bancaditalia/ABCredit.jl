# # Essential use of ABCredit

# We start by importing the ABCredit library and other useful libraries.

using ABCredit
using Statistics, Plots

# We then select the number of workers (W), the number of firms that produce consumption goods (F), 
# and the number of firms that produe capital goods (N).

W = 1000
F = 100
N = 20

# The other parameters of the model are stored in a dictionary. 
# Some standard parametrisations like the original one are readily available from the library.

params = ABCredit.PARAMS_ORIGINAL

# We can not initialise our model

model = ABCredit.initialise_model(W, F, N; params);

# Note that, after initialisation, the parameters of the model are accessible and modifiable as attributes of the model object.
# Here, for instance, we set the tax rate to 0.1

model.params[:tax_rate] = 0.0
model.params[:subsidy] = 0.0

# We run the mdel for an initial numbef of "burn-in" epochs for equilibration, 
# the simulation will output a data collector "d" with several time series.

# T_burn_in = 300
# d = ABCredit.run_one_sim!(model, T_burn_in; seed = 1)
# model.agg.timestep = 1

# Now we run the mdel for T epochs, the results simulation will output a data collector "d" with several time series.

T = 1000
d = ABCredit.run_one_sim!(model, T; seed = 100, burn_in = 100)

# If needed, we can save the simulation data to a CSV file as

ABCredit.save_csv(d, "data.csv")

# Now we can plot some of the store time series

p1 = plot(d.Y_real, title = "gdp", titlefont = 10)
p2 = plot(d.inflationRate, title = "inflation", titlefont = 10)
p3 = plot(d.Un, title = "unemployment", titlefont = 10)
p4 = plot(d.consumption, title = "consumption", titlefont = 10)
p5 = plot(d.totalDeb, title = "gross debt", titlefont = 10)
p6 = plot(d.Investment, title = "gross investment", titlefont = 10)
p7 = plot(d.totK, title = "capital stock", titlefont = 10)
p8 = plot(d.profitsB, title = "bank profits", titlefont = 10)
p9 = plot(d.E, title = "bank equity", titlefont = 10)

plot(p1, p2, p3, p4, p5, p6, p7, p8, p9, layout = (3, 3), legend = false)
