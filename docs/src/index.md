# EcologicalNetwork

This package provides a common interface for the analysis of ecological
networks, using `julia`. It is *very* opinionated about the "right" way to do
things, but we have documented our opinions in several publications.

About the analysis of ecological networks in general, the package covers (or
will cover over time) most of the measures we identified as robust in the
following publication:

> Delmas, Eva, Mathilde Besson, Marie-Helene Brice, Laura Burkle, Giulio V.
> Dalla Riva, Marie-Josée Fortin, Dominique Gravel, et al. “Analyzing Ecological
> Networks of Species Interactions.” BioRxiv, (2017), 112540.
> https://doi.org/10.1101/112540.

The analysis of network dissimilarity is done exactly as described in:

> Poisot, Timothée, Elsa Canard, David Mouillot, Nicolas Mouquet, and Dominique
> Gravel. “The Dissimilarity of Species Interaction Networks.” Ecology Letters
> 15, no. 12 (2012): 1353–1361. https://doi.org/10.1111/ele.12002.

The choice of measures for ecological specialisation is done according to:

> Poisot, Timothee, Elsa Canard, Nicolas Mouquet, and Michael E Hochberg. “A
> Comparative Study of Ecological Specialization Estimators.” Methods in Ecology
> and Evolution 3, no. 3 (2012): 537–44.
> https://doi.org/10.1111/j.2041-210X.2011.00174.x.

Finally, all of the measures for probabilistic networks are described in:

> Poisot, Timothée, Alyssa R. Cirtwill, Kévin Cazelles, Dominique Gravel,
> Marie-Josée Fortin, and Daniel B. Stouffer. “The Structure of Probabilistic
> Networks.” Methods in Ecology and Evolution 7, no. 3 (2016): 303–12.
> https://doi.org/10.1111/2041-210X.12468.
