#' ---
#' title : Understanding the type system
#' author : Timothée Poisot
#' date : 11th April 2018
#' layout: default
#' ---

using EcologicalNetwork
using Base.Test

N = fonseca_ganade_1996()

#' The type of networks have a hierarchy between them. We can test that this
#' network is bipartite:
@test typeof(N) <: AbstractBipartiteNetwork

#' We can also check that it is quantitative:
@test typeof(N) <: QuantitativeNetwork

#' Finally, we can also check that it is not probabilistic:
@test typeof(N) <: DeterministicNetwork
