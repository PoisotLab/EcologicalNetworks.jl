module EcologicalNetwork

# Dependencies
using StatsBase
using Combinatorics
using Luxor
using NamedTuples

# Various utilities for probabilities
include(joinpath(".", "misc/probabilities.jl"))

# Types
include(joinpath(".", "types/declarations.jl"))
include(joinpath(".", "types/constructors.jl"))
include(joinpath(".", "types/conversions.jl"))
export AbstractEcologicalNetwork, AllowedSpeciesTypes,
    # General types for all bipartite / unipartite
    AbstractBipartiteNetwork, AbstractUnipartiteNetwork,
    # Types
    BipartiteNetwork, UnipartiteNetwork,
    BipartiteProbabilisticNetwork, UnipartiteProbabilisticNetwork,
    BipartiteQuantitativeNetwork, UnipartiteQuantitativeNetwork,
    # Union types for all proba or deterministic
    ProbabilisticNetwork, DeterministicNetwork, QuantitativeNetwork,
    BinaryNetwork

# Datasets
include(joinpath(".", "misc/data.jl"))
export thompson_townsend_catlins, fonseca_ganade_1996, trojelsgaard_et_al_2014

# General useful manipulations
include(joinpath(".", "types/utilities.jl"))
export species, has_interaction, richness, nodiagonal

# Degree
include(joinpath(".", "links/degree.jl"))
export degree_out, degree_in, degree_out_var, degree_in_var, degree, degree_var

include(joinpath(".", "links/specificity.jl"))
export specificity

include(joinpath(".", "links/connectance.jl"))
export links, links_var, connectance, connectance_var,
    linkage_density, link_number

include(joinpath(".", "links/degenerate.jl"))
export isdegenerate, simplify#, species_has_no_successors, species_has_no_predecessors,
    #species_is_free, free_species

# Random networks and permutations
include(joinpath(".", "rand/draws.jl"))
include(joinpath(".", "rand/swaps.jl"))
include(joinpath(".", "rand/null.jl"))
export null1, null2, null3out, null3in

# Nestedness
include(joinpath(".", "community/nestedness.jl"))
export η, nodf

# Paths
include(joinpath(".", "community/paths.jl"))
export number_of_paths, shortest_path

# Centrality
include(joinpath(".", "community/centrality.jl"))
export centrality_katz, centrality_closeness, centrality_degree

# Motifs
include(joinpath(".", "community/motifs.jl"))
export find_motif, expected_motif_count, unipartitemotifs

# Modularity
include(joinpath(".", "modularity/utilities.jl"))
export Q, Qr

include(joinpath(".", "modularity/labelpropagation.jl"))
export lp

include(joinpath(".", "modularity/brim.jl"))
export brim

include(joinpath(".", "modularity/louvain.jl"))
export louvain

# Plots
include(joinpath(".", "plots/circular.jl"))
export circular_layout, circular_network_plot

include(joinpath(".", "plots/graph.jl"))
export graph_layout, graph_network_plot

# Beta-diversity
include(joinpath(".", "betadiversity/operations.jl"))
include(joinpath(".", "betadiversity/partitions.jl"))
export βs, βos, βwn

include(joinpath(".", "betadiversity/measures.jl"))
export whittaker, sorensen, jaccard, gaston, williams, lande, ruggiero,
    hartekinzig, harrison

#=

include(joinpath(".", "modularity/louvain.jl"))
include(joinpath(".", "modularity/modularity.jl"))
export modularity, networkroles
=#

#=
# Beta-diversity
fractional_trophic_level, trophic_level, foodweb_position

# Food webs measures
=#

end
