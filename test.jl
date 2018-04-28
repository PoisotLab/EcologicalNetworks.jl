include("./src/EcologicalNetwork.jl")
using EcologicalNetwork



N = simplify(nodiagonal(nz_stream_foodweb()[1]))
l = foodweb_layout(N; steps=100)
l = foodweb_layout(l...; steps=100)
graph_network_plot(l...; names=false)
