import Base.rand

"""
Returns a matrix B of the same size as A, in which each element B(i,j)
is 1 with probability A(i,j).
"""
function rand(N::ProbabilisticNetwork)
    # Get the correct network type
    newtype = typeof(N) <: AbstractUnipartiteNetwork ? UnipartiteNetwork : BipartiteNetwork
    return newtype(rand(size(N)).<=N.A, species_objects(N)...)
end

function rand{T<:Integer}(N::ProbabilisticNetwork, n::T)
    return map(x -> rand(N), 1:n)
end
