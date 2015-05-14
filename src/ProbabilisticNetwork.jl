module ProbabilisticNetwork

# Dependencies
using StatsBase
using Cairo

# Documentation
using Docile
#= XXX
This fugly piece of code checks if Base has a @doc macro (which means we are
working on 0.4), and if not, defaults back to the one provided by Docile. In a
perfect world, this will be a very short-lived block.
=#
try
  import Base.@doc
catch
  import Docile.@doc
end
using Lexicon

export nestedness, nestedness_axis,

  # Measures of centrality
  centrality_katz,

  # Links and connectances
  links, links_var, connectance, connectance_var,

  # Measures of degree
  degree_out, degree_in, degree_out_var, degree_in_var, degree, degree_var,

  # Expected number of species with 0 interactions
  species_has_no_successors, species_has_no_predecessors,
  species_is_free, free_species,

  # Matrix manipulation utilities
  make_unipartite, make_threshold, make_binary, make_bernoulli, nodiag,

  # Probability algebra utilities
  checkprob, i_esp, i_var, a_var, m_var,

  # NAIVE !!! null models
  null1, null2, null3out, null3in, nullmodel,

  # Draw
  draw_matrix,

  # Modularity
  Partition, Q, Qr, propagate_labels, modularity,

  # Paths
  number_of_paths,

  # Beta-diversity
  betadiversity,
  whittaker, sorensen, jaccard, gaston,
  williams, lande, ruggiero, hartekinzig,
  harrison,

  # Motifs
  motif_p, motif_v, count_motifs, motif, motif_var

@docstrings
@document

include(joinpath(".", "centrality.jl"))
include(joinpath(".", "connectance.jl"))
include(joinpath(".", "degree.jl"))
include(joinpath(".", "free_species.jl"))
include(joinpath(".", "matrix_utils.jl"))
include(joinpath(".", "nestedness.jl"))
include(joinpath(".", "proba_utils.jl"))
include(joinpath(".", "nullmodels.jl"))
include(joinpath(".", "draw.jl"))
include(joinpath(".", "modularity.jl"))
include(joinpath(".", "paths.jl"))
include(joinpath(".", "betadiversity.jl"))
include(joinpath(".", "motifs.jl"))

end
