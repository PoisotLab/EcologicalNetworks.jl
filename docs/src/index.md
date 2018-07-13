# EcologicalNetwork

This package provides a common interface for the analysis of ecological
networks, using `julia`. It is *very* opinionated about the "right" way to do
things, but we have documented our opinions in several publications (see the
references at the bottom of this page).

## Package philosophy

The package is built around a typesystem for networks, which is intended to
capture the different types of data and communities ecologists need to handle.
This makes the package extensible, both by writing additional methods with a
very fine-tuned dispatch, or by adding additional types that should work out of
the box (or be very close to).

This package is a *library* for the analysis of ecological networks. On purpose,
we do not provide "wrapper"-type functions that would perform an entire
analysis. We experimented with this idea during development, and rapidly
realized that even for the most simple research project, we needed to make small
tweaks that made the wrappers a nuisance. We decided to give you lego blocks,
and it's your job to build the kick-ass spaceship.

We tried to avoid making the package into yet another Domain Specific Language.
This means that when an operation should be expressed using the julian syntax,
we made it this way. Transforming networks from a type to another is done with
`convert`. Random networks are drawn with `rand`. Swapping of interactions is
done with `shuffle`. There is support for slicing of networks, as well as the
entire operations on sets. A lot of methods from `Base` have been overloaded,
and this *should* make the code easy to write and read.

## Why should I use this package?

It offers a single interface to analyse almost all type of networks for ecology.
It's somewhat fast. It's built around the very best practices in network
analysis. We think the type system is very cool. It's very well tested and
adequately documented. We used it for research and teaching for months before
releasing it. It's actively maintained and we will keep adding functionalities.

You don't have to use it if you don't want to.

### But it doesn't even make figures!

This will be coming soon.

### And it doesn't even generate random networks!

This will be coming sooner.

### And worse, you forgot my favorite method!

Yeah, about that. We probably didn't.

A lot of methods were considered for inclusion in the package, but ultimately
discarded because we were not 100% confident in their robustness, reliability,
validity, or interpretation. As we said, the package is *very* opinionated about
the right way to do things, and new functions require more time for maintenance
and testing; it makes sense for us to focus on things we trust.

If your favorite measure or method is missing, there are two solutions. First,
this package is essentialy a library of functions to build network analyses, so
you can use this to create a function that does what you want. For example, if
you want to take the square root of a quantitative network, you can overload the `√`
method from base this way:

~~~ julia
import Base: √

function √(N::T) where {T <: QuantitativeNetwork}
  # Get the new type for the output
  NewType = T <: AbstractBipartiteNetwork ? BipartiteQuantitativeNetwork : UnipartiteQuantitativeNetwork
  # Take the square root of the interaction strength
  sqrt_matrix = sqrt.(N.A)
  # Return a new network with the correct types
  return NewType{typeof(sqrt_matrix),eltype(N)[2]}(sqrt_matrix, EcologicalNetwork.species_objects(N)...)
end
~~~

The second solution (which is actually a second *step* after you have been
writing your own method), is to submit a pull request to the package, to have
your new methods available in the next release. Currently, we will be very
selective about which methods are added. In the future (presumably shortly after
the release of *Julia* `v1.0`), we will start a companion package to provide
additional methods.

## References

About the analysis of ecological networks in general, the package covers (or
will cover over time) most of the measures we identified as robust in the
following publication:

Delmas, Eva, Mathilde Besson, Marie-Helene Brice, Laura Burkle, Giulio V.
Dalla Riva, Marie-Josée Fortin, Dominique Gravel, et al. “Analyzing Ecological
Networks of Species Interactions.” BioRxiv, (2017), 112540.
https://doi.org/10.1101/112540.

We highly recommend we keep it nearby when using the package. A lot of decisions
taken during development are grounded in the analysis of the literature we
conducted over a few years.

### Network β-diversity

The analysis of network dissimilarity is done exactly as described in:

Poisot, Timothée, Elsa Canard, David Mouillot, Nicolas Mouquet, and Dominique
Gravel. “The Dissimilarity of Species Interaction Networks.” Ecology Letters 15,
no. 12 (2012): 1353–1361. https://doi.org/10.1111/ele.12002.

The measures for β-diversity (and the approach of partitioning variation in
sets) is done exactly as described in:

Koleff, Patricia, Kevin J. Gaston, and Jack J. Lennon. “Measuring Beta
Diversity for Presence–absence Data.” Journal of Animal Ecology 72, no. 3
(2003): 367–82. https://doi.org/10.1046/j.1365-2656.2003.00710.x.

The functions presented in their table are implemented as `KGLXX`, where `XX` is
the number of the function on two digits (*i.e.* the second measure of
β-diversity is `KGL02`).

### Specificity

Poisot, Timothee, Elsa Canard, Nicolas Mouquet, and Michael E Hochberg. “A
Comparative Study of Ecological Specialization Estimators.” Methods in Ecology
and Evolution 3, no. 3 (2012): 537–44.
https://doi.org/10.1111/j.2041-210X.2011.00174.x.

### Probabilistic networks

Poisot, Timothée, Alyssa R. Cirtwill, Kévin Cazelles, Dominique Gravel,
Marie-Josée Fortin, and Daniel B. Stouffer. “The Structure of Probabilistic
Networks.” Methods in Ecology and Evolution 7, no. 3 (2016): 303–12.
https://doi.org/10.1111/2041-210X.12468.
