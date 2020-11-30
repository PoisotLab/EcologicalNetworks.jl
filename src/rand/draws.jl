"""
    rand(N::ProbabilisticNetwork)

Converts a probabilistic network into a deterministic one by performing random
draws. All interactions are treated as independent Bernoulli events. Note that
this network is *not* check for degeneracy, *i.e.* species can end up with no
interactions.

#### References

- Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
  D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
  Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function Base.rand(N::ProbabilisticNetwork)
    # Get the correct network type
    newtype = typeof(N) <: AbstractUnipartiteNetwork ? UnipartiteNetwork : BipartiteNetwork
    int = interactions(N)
    I = zeros(Int64, length(int))
    J = zeros(Int64, length(int))
    V = zeros(Bool, length(int))
    for (i,idata) in enumerate(int)
        I[i] = findfirst(isequal(idata.from), species(N; dims=1))
        J[i] = findfirst(isequal(idata.to), species(N; dims=2))
        V[i] = rand() <= idata.probability
    end
    edges = sparse(I, J, V, richness(N; dims=1), richness(N; dims=2))
    dropzeros!(edges)
    K = newtype(edges, EcologicalNetworks._species_objects(N)...)
    return K
end

"""
    rand(N::ProbabilisticNetwork, n::T) where {T<:Integer}

Generates a number of random deterministic networks based on a probabilistic
network.

#### References

- Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
  D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
  Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function Base.rand(N::ProbabilisticNetwork, n::T) where {T<:Integer}
    @assert n > 0
    newtype = typeof(N) <: AbstractUnipartiteNetwork ? UnipartiteNetwork : BipartiteNetwork
    R = Vector{newtype}(undef, n)
    for i in 1:n
        R[i] = rand(N)
    end
    return R
end

"""
    rand(N::ProbabilisticNetwork, S::Tuple{Int64,Int64})

Generates a number of random deterministic networks based on a probabilistic
network, and returns them as a matrix.

#### References

- Poisot, T., Cirtwill, A.R., Cazelles, K., Gravel, D., Fortin, M.-J., Stouffer,
  D.B., 2016. The structure of probabilistic networks. Methods in Ecology and
  Evolution 7, 303–312. https://doi.org/10.1111/2041-210X.12468
"""
function Base.rand(N::ProbabilisticNetwork, S::Tuple{Int64,Int64})
    @assert minimum(S) > 0
    return reshape(rand(N, prod(S)), S)
end
