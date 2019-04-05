#=
Some functions from *Universal resilience patterns in complex networks*
by Gao et al. (2016)
=#

using Statistics: mean, std

# TODO : AbstractUnipartiteNetwork as type

s_in(N::UnipartiteNetwork) = mean(N.A, dims=2)
s_out(N::UnipartiteNetwork) = mean(N.A, dims=1)'
s_mean(N::UnipartiteNetwork) = mean(N.A)

σ_in(N::UnipartiteNetwork) = std(s_in(N))
σ_out(N::UnipartiteNetwork) = std(s_out(N))

symmetry(N::UnipartiteNetwork) = (mean(s_in(N) .* s_in(N)) - mean(s_in(N)) * mean(s_out(N))) / (σ_in(N)*σ_out(N))
heterogenity(N::UnipartiteNetwork) = σ_in(N) * σ_out(N) / s_mean(N)

βeff(N::UnipartiteNetwork) = mean(s_in(N) .* s_out(N)) / s_mean(N)
resilience(N) = βeff(N)
