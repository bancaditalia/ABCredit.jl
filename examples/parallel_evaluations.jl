# # Using multithreading for parallel model evaluations

# import ABCredit.jl and other useful libraries

using ABCredit, StatsPlots

params = ABCredit.PARAMS_ORIGINAL

# run 8 simulations in parallel and save the results in different CSV files

W = 1000
F = 100
N = 20

nsims = 8

T = 700

# remove the Government

params[:tax_rate] = 0.0
params[:subsidy] = 0.0

model = ABCredit.initialise_model(W, F, N; params);

d = ABCredit.run_n_sims(model, T, nsims; burn_in = 100)

# errorline the mean and the standard deviation of the collected series 

p1 = errorline(d.Y_real, title = "OUTPUT", titlefont = 10)
p2 = errorline(d.Y_nominal_tot, title = "OUTPUT (NOMINAL)", titlefont = 10)
p3 = errorline(d.gdp_deflator, title = "PRICE IND", titlefont = 10)
p4 = errorline(d.inflationRate, title = "INFLAITON", titlefont = 10)
p5 = errorline(d.consumption, title = "CONSUMPTION", titlefont = 10)
p6 = errorline(d.wb, title = "WAGE", titlefont = 10)
p7 = errorline(d.Un, title = "UNEMPLOYMENT", titlefont = 10)
p8 = errorline(d.bankruptcy_rate, title = "BANKRUPTCY RATE", titlefont = 10)
p9 = errorline(d.totalDeb, title = "DEBT P-FIRM", titlefont = 10)
p10 = errorline(d.totalDeb_k, title = "DEBT C-FIRM", titlefont = 10)
p11 = errorline(d.Investment, title = "INVESTMENT", titlefont = 10)
p12 = errorline(d.totK, title = "TOTAL CAPITAL", titlefont = 10)
p13 = errorline(d.inventories, title = "INVENTORIES", titlefont = 10)
p14 = errorline(d.inventories_k, title = "INVENTORIES CAP", titlefont = 10)
p15 = errorline(d.E, title = "BANK EQUITY", titlefont = 10)
p16 = errorline(d.dividendsB, title = "DIVIDEND", titlefont = 10)
p17 = errorline(d.profitsB, title = "PROFIT", titlefont = 10)
p18 = errorline(d.deposits, title = "DEPOSITS", titlefont = 10)

# plotting a fist set of variables

plot(p1, p2, p3, p4, p5, p6, p7, p8, p9, layout = (3, 3), legend = false)

# plotting a second set of variables

plot(p10, p11, p12, p13, p14, p15, p16, p17, p18, layout = (3, 3), legend = false)
