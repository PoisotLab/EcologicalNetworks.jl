module TestStochasticBlock
using Test
using EcologicalNetworks
using EcologicalNetworks: StochasticBlock
using Distributions: Categorical

labels = rand(Categorical([0.1 for i = 1:10]), 5000)
@test typeof(rand(StochasticBlock(labels, rand(10, 10)))) <: UnipartiteNetwork
@test richness(rand(StochasticBlock(labels, rand(10, 10)))) == 5000

@test_throws ArgumentError rand(StochasticBlock(labels, rand(50, 50)))

# mismatch between number of unique labels and block matrix size
@test_throws ArgumentError rand(
    StochasticBlock(rand(Categorical([0.1 for i = 1:9]), 50), rand(10, 10)),
)

# bipartite block model
tspecies, bspecies = 5000, 3000
tlabels, blabels = 10, 5
tdist = rand(Categorical([1 / tlabels for i = 1:tlabels]), tspecies)
bdist = rand(Categorical([1 / blabels for i = 1:blabels]), bspecies)
blocks = rand(tlabels, blabels)
@test typeof(rand(StochasticBlock((tdist, bdist), blocks))) <: BipartiteNetwork

# wrong size block matrix 
tspecies, bspecies = 5000, 3000
tlabels, blabels = 10, 5
tdist = rand(Categorical([1 / tlabels for i = 1:tlabels]), tspecies)
bdist = rand(Categorical([1 / blabels for i = 1:blabels]), bspecies)
blocks = rand(tlabels + 1, blabels)
@test_throws ArgumentError rand(StochasticBlock((tdist, bdist), blocks))

# wrong size labels matrix 
tspecies, bspecies = 5000, 3000
tlabels, blabels = 10, 5
tdist = rand(Categorical([1 / 5 for i = 1:5]), tspecies)
bdist = rand(Categorical([1 / 10 for i = 1:10]), bspecies)
blocks = rand(tlabels, blabels)
@test_throws ArgumentError rand(StochasticBlock((tdist, bdist), blocks))


end


