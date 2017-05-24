include("src/EcologicalNetwork.jl")

using EcologicalNetwork

using ProfileView

N = mcmullen()

m = BipartiteNetwork([0 1; 1 1])

@time motif(N, m)
@time motif(N, m)

@profile motif(N, m)

ProfileView.view()
