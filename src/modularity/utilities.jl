"""
**Get the δ matrix**

    delta_matrix(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

This matrix represents whether two nodes are part of the same module.
"""
function delta_matrix(N::AbstractBipartiteNetwork, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == richness(N,1)
  @assert length(BL) == richness(N,2)

  δ = TL .== BL'
  @assert size(δ) == size(N)

  # Return the 0/1 matrix
  return δ
end

function delta_matrix(N::AbstractUnipartiteNetwork, SL::Array{Int64, 1})
  @assert length(SL) == richness(N)

  δ = SL .== SL'
  @assert size(δ) == size(N)

  # Return the 0/1 matrix
  return δ
end

"""
**Modularity**

    Q(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

This measures modularity based on a matrix and a list of module labels. Note
that this function assumes that interactions are directional, so that
``A_{ij}`` represents an interaction from ``i`` to ``j``, but not the other way
around.
"""
function Q(N::AbstractBipartiteNetwork, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == size(N,1)
  @assert length(BL) == size(N,2)

  # Communities matrix
  δ = delta_matrix(N, L)

  # Degrees
  kin, kout = degree_in(N), degree_out(N)

  # Value of m -- sum of weights, total number of int, ...
  m = links(N)

  # Null model
  kikj = (kout .* kin')
  Pij = kikj ./ m

  # Difference
  diff = N.A .- Pij

  # Diff × delta
  dd = diff .* δ

  return sum(dd)/m
end

"""
**Realized modularity**

    Qr(N::AbstractEcologicalNetwork, L::Array{Int64, 1})

Measures realized modularity, based on a  a matrix and a list of module labels.
Realized modularity usually takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

The realized modularity is defined as ``Q_R' = 2\times (W/E) - 1``, where ``W``
is the number of links *within* modules, and ``E`` is the total number of links.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.
"""
function Qr(N::AbstractEcologicalNetwork, L::Array{Int64, 1})
  if length(unique(L)) == 1
    return 0.0
  end

  δ = delta_matrix(N, L)
  W = sum(N.A .* δ)
  E = links(N)
  return 2.0 * (W/E) - 1.0
end
