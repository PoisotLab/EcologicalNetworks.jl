module EcologicalNetworks

# Dependencies
using StatsBase
using Combinatorics

using Random
using DelimitedFiles
using LinearAlgebra

# Various utilities for probabilities
include(joinpath(".", "misc/probabilities.jl"))

# Tests to define what can be used in base types
include(joinpath(".", "misc/init_tests.jl"))

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
export web_of_life, nz_stream_foodweb

# General useful manipulations
include(joinpath(".", "types/utilities.jl"))
include(joinpath(".", "types/comparisons.jl"))
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
export null1, null2, null3out, null3in

# Nestedness
include(joinpath(".", "community/nestedness.jl"))
export η, nodf

# Paths
include(joinpath(".", "community/paths.jl"))
export number_of_paths, shortest_path, bellman_ford

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
export lp, salp

include(joinpath(".", "modularity/starters.jl"))
export n_random_modules, each_species_its_module

include(joinpath(".", "modularity/brim.jl"))
export brim

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

end
