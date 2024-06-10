# # Use ABCredit to simulate the model and compare the results with real FRED data

# we start by importing the ABCredit library and other useful libraries.

using ABCredit, Statistics, Plots, DelimitedFiles

# install the HPFilter and KernelDensity packages
using Pkg
Pkg.add(url="https://github.com/sdBrinkmann/HPFilter.jl")
Pkg.add("KernelDensity")
using HPFilter, KernelDensity

# instantiate a standard model

W = 1000
F = 100
N = 20

params = ABCredit.PARAMS_GRAZZINI
model = ABCredit.initialise_model(W, F, N; params)

T = 1000
d = ABCredit.run_one_sim!(model, T; seed = 100, burn_in = 300)

# select some variables
Y  = d.Y_real;
P  = d.gdp_deflator;
I  = d.Investment;
C  = d.consumption;
U = d.Un;

# load the data from FRED_data.txt
dir = @__DIR__
data = readdlm(dir*"/FRED_data.txt", ' ', skipstart=1)
y_real = data[:, 1];
pi_real = data[:, 2];
invest_real = data[:, 3];
c_real = data[:, 4];
u_real = data[:, 5];

# apply HP filter to the simulated data
y = log.(Y) - HP(log.(Y),1600);
c = log.(C) - HP(log.(C),1600);
invest = log.(I) - HP(log.(I),1600);
u = U;
pi = diff(log.(P)) .- mean((diff(log.(P))));

# plot the histograms of real and simulated data
pdf_sim = kde(u);
pdf_real = kde(u_real);
p1 = plot([pdf_sim.density, pdf_real.density], title = "unemployment rate", titlefont = 10, labels=["simulated" "real"])

pdf_sim = kde(y);
pdf_real = kde(y_real);
p2 = plot([pdf_sim.density, pdf_real.density], title = "output gap", titlefont = 10, legend = :none)

pdf_sim = kde(pi);
pdf_real = kde(pi_real);
p3 = plot([pdf_sim.density, pdf_real.density], title = "inflation rate", titlefont = 10, legend = :none)

pdf_sim = kde(c);
pdf_real = kde(c_real);
p4 = plot([pdf_sim.density, pdf_real.density], title = "consumption gap", titlefont = 10, legend = :none)

pdf_sim = kde(invest);
pdf_real = kde(invest_real);
p5 = plot([pdf_sim.density, pdf_real.density], title = "investment gap", titlefont = 10, legend = :none)

plot(p1, p2, p3, p4, p5, layout = (2, 3))