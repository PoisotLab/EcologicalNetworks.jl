module EcologicalNetwork

# Dependencies
using StatsBase
using Combinatorics

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
export thompson_townsend_catlins

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
export isdegenerate#, species_has_no_successors, species_has_no_predecessors,
    #species_is_free, free_species

# Random networks and permutations
include(joinpath(".", "rand/draws.jl"))

#=
# Nestedness
export η, nodf,

# Measures of centrality
centrality_katz, centrality_closeness, centrality_degree,

# Matrix manipulation utilities
make_unipartite, make_threshold, make_binary, make_bernoulli,

# Null models
null1, null2, null3out, null3in, nullmodel,

# Swap
swaps, swap,

# Testing
test_network_property,

# Modularity
Partition, Q, Qr, modularity, best_partition, networkroles,

# Modularity - specifics
label_propagation, louvain, brim, lpbrim,

# Paths
number_of_paths, shortest_path,

# Beta-diversity
betadiversity,
whittaker, sorensen, jaccard, gaston,
williams, lande, ruggiero, hartekinzig,
fractional_trophic_level, trophic_level, foodweb_position
harrison,

# Motifs
motif_p, motif_v, count_motifs, motif, motif_var, unipartitemotifs,

# Data
stony, mcmullen, ollerton, bluthgen, robertson, woods, kato, soilphagebacteria,

# Food webs measures
=#

#include(joinpath(".", "centrality.jl"))
#include(joinpath(".", "connectance.jl"))
#include(joinpath(".", "degree.jl"))
#include(joinpath(".", "free_species.jl"))
#include(joinpath(".", "matrix_utils.jl"))
#include(joinpath(".", "nestedness.jl"))
#include(joinpath(".", "proba_utils.jl"))
#include(joinpath(".", "nullmodels.jl"))
#include(joinpath(".", "swaps.jl"))
#include(joinpath(".", "modularity/modularity.jl"))
#include(joinpath(".", "modularity/louvain.jl"))
#include(joinpath(".", "modularity/labelpropagation.jl"))
#include(joinpath(".", "modularity/brim.jl"))
#include(joinpath(".", "modularity/lpbrim.jl"))
#include(joinpath(".", "paths.jl"))
#include(joinpath(".", "betadiversity.jl"))
#include(joinpath(".", "motifs.jl"))
#include(joinpath(".", "data.jl"))
#include(joinpath(".", "test.jl"))
#include(joinpath(".", "draw.jl"))
#include(joinpath(".", "foodwebs.jl"))

end
