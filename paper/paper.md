---
title: 'EcologicalNetworks.jl: A Julia package for analyzing networks of species interactions'
tags:
  - Julia
  - ecological networks
  - food webs
  - species interactions
  - graph theory

authors:
  - name: Francis Banville^[corresponding author]
    orcid: 0000-0001-9051-0597
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Timothée Poisot
    orcid: 0000-0002-0735-5184
    affiliation: 1
affiliations:
 - name: Dept of biology, Université de Montréal, Canada
   index: 1
 - name: Dept of biology, Université de Sherbrooke, Canada
   index: 2
date: 14 September 2020
bibliography: paper.bib
---


# Summary
Network ecology is an emerging field of study describing species interactions (e.g. predation, pollination) in a biological community. Ecological networks, in which two species are connected if they can interact, are a mathematical representation of all interactions encountered in a given ecosystem. Anchored in graph theory, the methods developed in network ecology are remarkably rigorous and biologically insightful. Indeed, many ecological and evolutionary processes are driven by species interactions and network structure (i.e. the arrangement of links in ecological networks). The study of ecological networks, from data importation and simulation to data analysis and visualization, require a coherent and efficient set of numerical tools. With its powerful and dynamic type system, the Julia programming language provides a solid computing environment in this regard. `EcologicalNetworks.jl` is a novel Julia package designed to conduct these numerical analysis in an integrated environment for ecological research in Julia.

# Statement of need
Analyzing ecological networks is a challenging task. Several measures are commonly used to characterize the structure of ecological networks, and their implementation can sometimes be arduous. Further, different methods are used for different types of networks.

# Type system
Ecological networks are of various types, and the analysis of each of these types requires slightly different numerical methods. The vast majority of networks of species interactions in fact fall into two broad categories: monopartite and bipartite networks. Pollination networks are a common example of bipartite networks where members of a set of species (pollinators) interact exclusively with members of a second set (plants). In contrast, food webs, for instance, are monopartite networks because species can not be clearly subdivided into two distinctive groups. Furthermore, ecological networks, whether they are monopartite or bipartite, can also be deterministic or probabilistic. In deterministic networks, pairwise interactions are binary when they represent the presence or absence of an interaction between two species; they are on the other hand quantitative when interaction strengths are encoded. In probabilistic networks, pairwise interactions represent the probability that two species interact in a given environment. These types of networks are all represented in a hierarchical system of types in `EcologicalNetworks.jl`. This greatly facilitates their manipulation and analysis.

# Simulation and analysis

# Illustration


# Integrated environment
`Mangal.jl`
`EcologicalNetworksPlots.jl`


# Acknowledgements

We acknowledge contributions from Steve Vissault, Zachary Bélisle, Laura Hoebeke, Michiel Stock and Piotr Szefer for their help in the development of theses packages.

# References
