#=
Some functions from *Universal resilience patterns in complex networks*
by Gao et al. (2016)
=#

using StatsBase: mean, std

s_in(N::AbstractUnipartiteNetwork) = sum(N.A, dims=2)
s_out(N::AbstractUnipartiteNetwork) = sum(N.A, dims=1)'
s_mean(N::AbstractUnipartiteNetwork) = sum(N.A) / size(N.A, 1)

σ_in(N::AbstractUnipartiteNetwork) = std(s_in(N), corrected=false)
σ_out(N::AbstractUnipartiteNetwork) = std(s_out(N), corrected=false)

# symmetry computed wrongly in paper?
symmetry(N::AbstractUnipartiteNetwork) = (mean(s_in(N) .* s_out(N)) - mean(s_in(N)) * mean(s_out(N))) / (σ_in(N) * σ_out(N))
heterogenity(N::AbstractUnipartiteNetwork) = (σ_in(N) * σ_out(N)) / s_mean(N)

βeff(N::AbstractUnipartiteNetwork) = dot(s_in(N), s_out(N)) / sum(N.A)
resilience(N::AbstractUnipartiteNetwork) = βeff(N)

# check if  βeff = sum(A *s_in) / sum(A)
# and βeff = <s> + HS
