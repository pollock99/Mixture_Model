using Statistics
using Distributions
using CSV
using DataFrames
using Plots
using Vega

data1=CSV.read("C:/~/s1.csv",DataFrame)
data2=CSV.read("C:/~/s2.csv",DataFrame)
data3=CSV.read("C:/~/seoul.csv",DataFrame)


y1=data1[!,"y"]
y2=data2[!,"y"]
y=data3[!,"y"]
x1=data1[!,"year"]
x2=data2[!,"year"]
x=data3[!,"year"]



# Series plot ===============================================
scatter(x1,y1, legend = nothing, color=:red)
plot!(x1,y1, color=:black)
xlabel!("Year")
ylabel!("Annual Rainfall Maximum Value")
ylims!(0,400)

scatter(x2,y2, legend = nothing, color=:red)
plot!(x2,y2, color=:black)
xlabel!("Year")
ylabel!("Annual Rainfall Maximum Value")
ylims!(0,400)

# b_range = range(0,400,length=15)
# histogram(y1,bins=b_range,legend = nothing, color=:white)
# title!("1961 - 1990")

# histogram(y2,bins=b_range,legend = nothing, color=:white)
# title!("1991 - 2020")


scatter(x1,y1, legend = nothing, color=:red, markerstrokewidth = 0)
plot!(x1,y1, color=:red)
xlabel!("Year")
ylabel!("Annual Rainfall Maximum Value")
ylims!(0,400)

scatter!(x2,y2, legend = nothing, color=:blue, markerstrokewidth = 0)
plot!(x2,y2, color=:blue)
xlabel!("Year")
ylabel!("Annual Rainfall Maximum Value")
ylims!(0,400)



py"""
import numpy as np

def sinpi(x):
    return np.sin(np.pi * x)

"""
py"sinpi"(1)







# QQ plot ===================================================
# using Distributions, RecipesBase

# @recipe function f(h::QQPair)
#     seriestype --> :scatter
#     h.qx, h.qy
# end

# @userplot QQPlot
# @recipe f(h::QQPlot) = qqbuild(h.args[1], h.args[2])
    
# @userplot QQNorm
# @recipe f(h::QQNorm) = qqbuild(Normal(), h.args[1])

# @userplot QQGumbel
# @recipe f(h::QQGumbel) = qqbuild(Gumbel(), h.args[1])

# @userplot QQLognormal
# @recipe f(h::QQLogNormal) = qqbuild(LogNormal(), h.args[1])

#x = rand(Normal(), 100)
#y = rand(Cauchy(), 100)

# x=y1

# using Plots
# qqplot(x,x)
# qqnorm(x,label="Data",color=:red)

# x_range = range(-2,4,length=10000)
# y_range = 100 .+ 50 .* x_range
# plot!(x_range,y_range,color=:black, label="Test line",ls=:dash)
# title!("Gumbel")


# 2-component?
using Roots, Printf
function gumbel_fit(data)
    f(x) = x - mean(data) + sum(data .* exp.(-data ./ x)) / sum(exp.(-data ./ x)) 
    σ = find_zero(f,sqrt(6)*std(data)/pi) # moment estimator as initial value
    μ = - σ * log(sum(exp.(-data./σ))/length(data))
    return μ , σ
end #function

function gumbel_fit_plots(data,label) 
n = length(data)
data = reshape(data,n,1)
μ , σ = gumbel_fit(data)
X = collect(LinRange(minimum(data),maximum(data),1000))
tmp = (X.-μ)/σ
Y = exp.(-tmp.-exp.(-tmp))./σ
#pyplot()
# histogram(data,
#             #nbins = round(Int,sqrt(n)),
#             normalize = true,
#             label = @sprintf("%s histogram n=%i",label,n),
#             color = :white)
plot(X,Y,
        #title = @sprintf("Gumbel density μ=%2.2f σ=%2.2f",μ,σ),
        label = @sprintf("1961-1990 Gumbel density \n ( μ=%2.2f σ=%2.2f )",μ,σ),
        lw = 3,
        linestyle = :solid, 
        linecolor = :red,
        grid = :x,
        border = false)
        #gui()
end #function

function gumbel_fit_plots2(data,label) 
    n = length(data)
    data = reshape(data,n,1)
    μ , σ = gumbel_fit(data)
    X = collect(LinRange(minimum(data),maximum(data),1000))
    tmp = (X.-μ)/σ
    Y = exp.(-tmp.-exp.(-tmp))./σ
    #pyplot()
    # histogram!(data,
    #             #nbins = round(Int,sqrt(n)),
    #             normalize = true,
    #             label = @sprintf("%s histogram n=%i",label,n),
    #             color = :white)
    plot!(X,Y,
            #title = @sprintf("Gumbel density μ=%2.2f σ=%2.2f",μ,σ),
            label = @sprintf("\n1991-2020 Gumbel density \n ( μ=%2.2f σ=%2.2f )",μ,σ),
            lw = 3,
            linestyle = :solid, 
            linecolor = :blue,
            grid = :x,
            border = false,
            fg_legend = :transparent)
            #gui()
end #function
    
function gumbel_fit_plots3(data,label) 
    n = length(data)
    data = reshape(data,n,1)
    μ , σ = gumbel_fit(data)
    X = collect(LinRange(minimum(data),maximum(data),1000))
    tmp = (X.-μ)/σ
    Y = exp.(-tmp.-exp.(-tmp))./σ
    #pyplot()
    # histogram!(data,
    #             #nbins = round(Int,sqrt(n)),
    #             normalize = true,
    #             label = @sprintf("%s histogram n=%i",label,n),
    #             color = :white)
    plot!(X,Y,
            #title = @sprintf("Gumbel density μ=%2.2f σ=%2.2f",μ,σ),
            label = @sprintf("\n1961-2020 Gumbel density \n ( μ=%2.2f σ=%2.2f )",μ,σ),
            lw = 1,
            linestyle = :dash, 
            linecolor = :black,
            grid = :x,
            border = false,
            fg_legend = :transparent)
            #gui()
end #function

# function gumbel_fit_example()
#     gumbel_fit_plots(-log(-log(rand(1,1000))),"Sample") 
# end #function

gumbel_fit_plots(y1,"Data")
gumbel_fit_plots2(y2,"Data")
gumbel_fit_plots3(y, "Data")
ylabel!("Density")
xlabel!("Annual Rainfall Maximum value (mm)")
ylims!(-0.001,0.01)
scatter!(y1,[-0.0001], color=:red, markerstrokewidth = 0, label=nothing)
scatter!(y2,[-0.0004], color=:blue, markerstrokewidth = 0, label=nothing)

# latex example ==========================================================

x = 0:0.05:4π
y1 = sin.(3x) ./ ((cos.(x)) .+ 2) ./ x
y2 = cos.(x) ./ x 
y3 = exp.(-x)
plot(x, [y1 y2 y3], label=[L"\frac{\sin(3x)}{x(\cos(x)+2)}" L"\cos(x)/x" L"e^{-x}"],
        labelsize=15)
ylims!(-0.5,1)
title!(L"\mathrm{TeX\,representation:\,} y = f(x)")
