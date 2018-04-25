function brim{T<:BipartiteNetwork}(N::T, TL::Array{Int64, 1}, BL::Array{Int64, 1})
  @assert length(TL) == richness(N,1)
  @assert length(BL) == richness(N,2)

  old_Q = Q(N, TL, BL)
  new_Q = old_Q+0.00001

  m = links(N)

  # R and T matrices
  nBL = zeros(BL)
  nTL = zeros(TL)
  for (i, l) in enumerate(unique(vcat(TL,BL)))
    nBL[BL.==l] = i
    nTL[TL.==l] = i
  end


  TL, BL = deepcopy(nTL), deepcopy(nBL)
  c = length(unique(vcat(BL, TL)))
  R = map(Int64, TL .== collect(1:c)')
  T = map(Int64, BL .== collect(1:c)')

  B = N.A .- null2(N).A

  while old_Q < new_Q

    t_tilde = B*T
    R = map(Int64, t_tilde .== maximum(t_tilde, 2))
    r_tilde = B'*R
    T = map(Int64, r_tilde .== maximum(r_tilde, 2))
    S = vcat(R, T)
    L = vec(mapslices(r -> StatsBase.sample(find(r)), S, 2))
    TL = L[1:richness(N,1)]
    BL = L[(end-richness(N,2)+1):end]

    old_Q = new_Q
    new_Q = Q(N,TL, BL)

  end

  return (N, TL, BL)

end
