using ABCredit

params = ABCredit.PARAMS_ORIGINAL

T = 1000 # number of epochs
W = 1000 # number of workers
F = 100  # Int(round(W / 10.0)) # number of consumption firms
N = 20   # Int(round(W / 50.0)) # number of capital firms

# remove the government
params[:tax_rate] = 0.0
params[:subsidy] = 0.0

# initialise the model
model = ABCredit.initialise_model(W, F, N; params);

# run a simulation
@time d = ABCredit.run_one_sim!(model, T; seed = 100, burn_in = 300);

# optionally, save the data to a CSV file
# ABCredit.save_csv(d, "m_df.csv")

# plot some of the stored time series, make sure to have the Plots.jl package installed
# you can install it by running `using Pkg; Pkg.add("Plots")`
using Plots

p1 = plot(d.Y_real, title = "OUTPUT", titlefont = 10)
p2 = plot(d.Y_nominal_tot, title = "OUTPUT (NOMINAL)", titlefont = 10)
p3 = plot(d.gdp_deflator, title = "PRICE IND", titlefont = 10)
p4 = plot(d.inflationRate, title = "INFLAITON", titlefont = 10)
p5 = plot(d.consumption, title = "CONSUMPTION", titlefont = 10)
p6 = plot(d.wb, title = "WAGE", titlefont = 10)
p7 = plot(d.Un, title = "UNEMPLOYMENT", titlefont = 10)
p8 = plot(d.bankruptcy_rate, title = "BANKRUPTCY RATE", titlefont = 10)
p9 = plot(d.totalDeb, title = "DEBT P-FIRM", titlefont = 10)
p10 = plot(d.totalDeb_k, title = "DEBT C-FIRM", titlefont = 10)
p11 = plot(d.Investment, title = "INVESTMENT", titlefont = 10)
p12 = plot(d.totK, title = "TOTAL CAPITAL", titlefont = 10)
p13 = plot(d.inventories, title = "INVENTORIES", titlefont = 10)
p14 = plot(d.inventories_k, title = "INVENTORIES CAP", titlefont = 10)
p15 = plot(d.E, title = "BANK EQUITY", titlefont = 10)
p16 = plot(d.dividendsB, title = "DIVIDEND", titlefont = 10)
p17 = plot(d.profitsB, title = "PROFIT", titlefont = 10)
p18 = plot(d.GB, title = "GOVT. BALANCE", titlefont = 10)
p19 = plot(d.deficitGDP, title = "DEFICIT", titlefont = 10)
p20 = plot(d.bonds, title = "BONDS", titlefont = 10)
p21 = plot(d.reserves, title = "RESERVES", titlefont = 10)
p21 = plot(d.deposits, title = "DEPOSITS", titlefont = 10)
plot(p1, p2, p3, p4, p5, p6, p7, p8, p9, layout = (3, 3), legend = false)
plot(p10, p11, p12, p13, p14, p15, p16, p17, p18, layout = (3, 3), legend = false)
