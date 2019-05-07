module EcologicalNetworks

# Dependencies
using StatsBase
using Combinatorics
using Distributions

using Random
using DelimitedFiles
using LinearAlgebra
using DataStructures

using Requires

# Various utilities for probabilities
include(joinpath(".", "misc/probabilities.jl"))

# Tests to define what can be used in base types
include(joinpath(".", "misc/init_tests.jl"))

# Types
include(joinpath(".", "types/declarations.jl"))
include(joinpath(".", "types/constructors.jl"))
include(joinpath(".", "types/conversions.jl"))
export AbstractEcologicalNetwork,
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
export web_of_life, nz_stream_foodweb

# Mangal -- only exports `convert` methods
#using Mangal
function __init__()
   @require Mangal="b8b640a6-63d9-51e6-b784-5033db27bef2" is_valid_species(::Mangal.MangalNode) = true
   @require Mangal="b8b640a6-63d9-51e6-b784-5033db27bef2" is_valid_species(::Mangal.MangalReferenceTaxon) = true
   @require GBIF="ee291a33-5a6c-5552-a3c8-0f29a1181037" is_valid_species(::GBIF.GBIFTaxon) = true
end

# General useful manipulations
include(joinpath(".", "types/utilities.jl"))
include(joinpath(".", "types/comparisons.jl"))
include(joinpath(".", "types/iteration.jl"))
export species, interactions, has_interaction, richness, nodiagonal, nodiagonal!

# Degree
include(joinpath(".", "links/degree.jl"))
export degree, degree_var

include(joinpath(".", "links/specificity.jl"))
export specificity

include(joinpath(".", "links/connectance.jl"))
export links, L, links_var, connectance, connectance_var,
   linkage_density, link_number

include(joinpath(".", "links/degenerate.jl"))
export isdegenerate, simplify, simplify!
   #, species_has_no_successors, species_has_no_predecessors,
   #species_is_free, free_species

# Random networks and permutations
include(joinpath(".", "rand/draws.jl"))
include(joinpath(".", "rand/sample.jl"))
export sample
include(joinpath(".", "rand/shuffle.jl"))
include(joinpath(".", "rand/null.jl"))
include(joinpath(".", "rand/linfilter.jl"))
export linearfilter, linearfilterzoo
export null1, null2, null3, null4

# Random networks from structural models
include(joinpath(".", "structuralmodels/cascademodel.jl"))
export cascademodel
include(joinpath(".", "structuralmodels/mpnmodel.jl"))
export mpnmodel
include(joinpath(".", "structuralmodels/nestedhierarchymodel.jl"))
export nestedhierarchymodel
include(joinpath(".", "structuralmodels/nichemodel.jl"))
export nichemodel

# Nestedness
include(joinpath(".", "community/nestedness.jl"))
export η, nodf

# Paths
include(joinpath(".", "community/paths.jl"))
export number_of_paths, shortest_path, bellman_ford, dijkstra

# Centrality
include(joinpath(".", "community/centrality.jl"))
export centrality_katz, centrality_closeness, centrality_degree

# Motifs
include(joinpath(".", "community/motifs.jl"))
export find_motif, expected_motif_count, unipartitemotifs

# Overlap
include(joinpath(".", "community/overlap.jl"))
export overlap
export AJS, EAJS

# Modularity
include(joinpath(".", "modularity/utilities.jl"))
export Q, Qr

include(joinpath(".", "modularity/labelpropagation.jl"))
export lp, salp

include(joinpath(".", "modularity/starters.jl"))
export n_random_modules, each_species_its_module

include(joinpath(".", "modularity/brim.jl"))
export brim

include(joinpath(".", "modularity/roles.jl"))
export functional_cartography

# Beta-diversity
include(joinpath(".", "betadiversity/operations.jl"))
include(joinpath(".", "betadiversity/partitions.jl"))
export βs, βos, βwn

include(joinpath(".", "betadiversity/measures.jl"))
export KGL01, KGL02, KGL03, KGL04, KGL05, KGL06, KGL07, KGL08, KGL09, KGL10,
   KGL11, KGL12, KGL13, KGL14, KGL15, KGL16, KGL17, KGL18, KGL19, KGL20, KGL21,
   KGL22, KGL23, KGL24

# Food webs
include(joinpath(".", "foodwebs/trophiclevels.jl"))
export fractional_trophic_level, trophic_level

include(joinpath(".", "information/entropy.jl"))
export entropy, make_joint_distribution, mutual_information, conditional_entropy,
   variation_information, diff_entropy_uniform, information_decomposition,
   convert2effective, potential_information

end
