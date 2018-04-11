#' ---
#' title : Case study 1 - generalities about the package
#' author : Timothée Poisot
#' date : 11th April 2018
#' ---

using EcologicalNetwork

#+ echo=false
using Base.Test

#' The purpose of this case study is to illustrate the ways to access
#' information about the different types, and how to manipulate the networks. It
#' contains a few lines starting with `@test` -- this is because when validating
#' the code, the case studies are part of the test suite. If one of the line
#' starting by `@test` return an error, there is something wrong with the
#' package.

#' We start by loading a network, in this case the one by Fonseca & Ganade
#' (1996). This is a bipartite network.
N = fonseca_ganade_1996()

#' Let's look at the type of this network:
typeof(N)

#+ echo=false; results="hidden"
@test typeof(N) == BipartiteQuantitativeNetwork{Int64,String}

#' This is a bipartite network, which contains quantitative information about
#' species interactions, stored as `Int64`. The species are identified by
#' `String` objects.

#' The type of networks have a hierarchy between them. We can test that this
#' network is bipartite:
@test typeof(N) <: AbstractBipartiteNetwork

#' We can also check that it is quantitative:
@test typeof(N) <: QuantitativeNetwork

#' Finally, we can also check that it is not probabilistic:
@test typeof(N) <: DeterministicNetwork

#' This is a network with 25 insects and 16 plants. We can check that this
#' richness is indeed 41::
richness(N)

#+ echo=false; results="hidden"
@test richness(N) == 25+16

#' We can check the number of species on either side, using another method for
#' `richness`:
@test richness(N,1) == 25
richness(N,1)

#' The side `1` is the top-level species, and the side `2` is the bottom-level
#' species. Interactions go from species on side `1` to species on side `2`.

#' We can look at the species that make up all sides:
species(N)

#' Note that this also works for either side:
species(N,2)

#' We can look for the presence of interactions between species in a few
#' different ways. First, we can use their *position* in the network:
N[3,4]

#' But it's probably more intuitive to look at the species by names:
t3 = species(N,1)[3]
b4 = species(N,2)[4]
t3, b4

#' We can access the interaction between these species:
N[t3,b4]

#' The package also offers a way to test the *existence* of an interaction,
#' regardless of the network type:
has_interaction(N, t3,b4)

#+ echo=false;results="hidden"
@test has_interaction(N, t3,b4)

#' An interesting thing we can do is extract a subset of the network using
#' collections of species. We will extract the species belonging to the genus
#' *Azteca*, and to the genus *Cecropia*:
all_azteca = filter(x -> contains(x, "Azteca "), species(N,1))
all_cecropia = filter(x -> contains(x, "Cecropia "), species(N,2))

#' Now, we can get a sub-network (the induced subgraph on these nodes):
M = N[all_azteca, all_cecropia]

#' We can also use slices in a more general way, for example to have all
#' interactions from the *Azteca* genus:
N[all_azteca,:]

#+ echo=false; results="hidden"
@test richness(N[all_azteca,:],1) == length(all_azteca)
@test richness(N[all_azteca,:],2) == richness(N,2)

#' Note how extracting by collections of species names returns another network,
#' of the same type as the parent!
typeof(M)

#+ echo=false; results="hidden"
@test typeof(M) == typeof(N)

#' We can ask a few questions about the degree of this induced network:
degree(N)

#' We can also look at the degree on either sides, for example the degree of
#' plants (*i.e.* number of insects interacting with them):
degree(N,2)

#+ echo=false; results="hidden"
@test degree(N,2)["Maieta guianensis"] == 3
