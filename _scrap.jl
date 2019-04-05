using Pkg
Pkg.activate(".")
using EcologicalNetworks

N = nz_stream_foodweb()[1]

x = [cascademodel(N) for i in 1:200]
