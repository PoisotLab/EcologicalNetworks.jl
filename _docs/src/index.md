# EcologicalNetworks

This package provides a common interface for the analysis of ecological
networks, using `julia`. It is *very* opinionated about the "right" way
to do things, but we have documented our opinions in several publications
(see the references at the bottom of this page, and in the documentation of
all functions).

The package is built around a type system for networks, which is intended to
capture the different types of data and communities ecologists need to handle.
This makes the package extensible, both by writing additional methods with
a very fine-tuned dispatch, or by adding additional types that should work
out of the box (or be very close to).

This package is a *library* for the analysis of ecological networks. On purpose,
we do not provide "wrapper"-type functions that would perform an entire
analysis. We experimented with this idea during development, and rapidly
realized that even for the most simple research project, we needed to make small
tweaks that made the wrappers a nuisance. We decided to give you lego blocks,
and it's your job to build the kick-ass spaceship.

We tried to avoid making the package into yet another Domain Specific Language.
This means that when an operation should be expressed using the julian syntax,
we made it this way. Transforming networks from a type to another is done with
`convert`. Random networks are drawn with `rand`. Swapping of interactions
is done with `shuffle`. There is support for slicing of networks, as well
as the entire operations on sets. A lot of methods from `Base` have been
overloaded, and this *should* make the code easy to write and read, since
it looks almost exactly like any other *Julia* code on arrays.

### Why should I use this package?

It offers a single interface to analyse almost all type of networks for ecology.
It's somewhat fast (very specialized packages are likely to be faster). It's
built around the very best practices in network analysis. We think the type
system is very cool. It's very well tested and adequately documented. We used it
for research and teaching for months before releasing it. It's actively
maintained and we will keep adding functionalities.

You don't have to use it if you don't want to.

### But it doesn't even make figures!

The code for network visualization is in a companion package named
`EcologicalNetworksPlots`. There are two reasons for this decision.

First, network visualization, although attractive, is not necessary for network
analysis. It can help, but given the wrong network layout technique, it can also
introduce biases. When the volume of networks increased, we found that
visualization became less and less informative. Because it is not strictly
speaking a tool for analysis, it is not part of this package.

Second, it helps to keep software dependency small. Most of our work using this
package is done on clusters of one sort of the other, and having fewer
dependencies means that installation is easier. `EcologicalNetworksPlots` can be
installed like any other Julia package. It is also documented on [its own
website][ENP].

[ENP]: https://poisotlab.github.io/EcologicalNetworksPlots.jl/stable/

### And worse, you forgot my favorite method!

Yeah, about that. We probably didn't.

A lot of methods were considered for inclusion in the package, but ultimately
discarded because we were not 100% confident in their robustness, reliability,
validity, or interpretation. As we said, the package is *very* opinionated about
the right way to do things, and new functions require more time for maintenance
and testing; it makes sense for us to focus on things we trust.

If your favorite measure or method is missing, there are two solutions. First,
this package is essentially a library of functions to build network analyses, so
you can use this to create a function that does what you want. For example, if
you want to take the square root of a quantitative network, you can overload the
`√` method from base this way:

~~~ julia
import Base: √

function √(N::T) where {T <: QuantitativeNetwork}
   @assert all(N.edges .> zero(eltype(N.edges)))
   # Take the square root of the interaction strength
   sqrt_matrix = sqrt.(N.edges)
   # Return a new network with the correct types
   return T(sqrt_matrix, EcologicalNetworks._species_objects(N)...)
end
~~~

The second solution (which is actually a second *step* after you have been
writing your own method), is to submit a pull request to the package, to have
your new methods available in the next release. Currently, we will be very
selective about which methods are added (because every line of code needs to be
maintained).

## References

About the analysis of ecological networks in general, the package covers (or
will cover over time) most of the measures we identified as robust in the
following publication:

Delmas, Eva, Mathilde Besson, Marie-Hélène Brice, Laura A. Burkle, Giulio V.
Dalla Riva, Marie-Josée Fortin, Dominique Gravel, et al. « Analysing Ecological
Networks of Species Interactions ». Biological Reviews (2018), 112540.
https://doi.org/10.1111/brv.12433.


We highly recommend we keep it nearby when using the package. A lot of
decisions taken during development are grounded in the analysis of the
literature we conducted over a few years. Anything else is now documented
in the functions themselves.

## How can I contribute?

Good question!

The easiest way to contribute is to use the package, and [open an issue][issue]
whenever you can't manage to do something, think the syntax is not clear, or
the documentation is confusing. This is in fact one of the best ways to help.

[issue]: https://github.com/PoisotLab/EcologicalNetworks.jl/issues

If you want to contribute code, you can fork this repository, and start adding
the functions you want, or changing the code. Please work from the `develop`
branch (`master` does not accept pull requests except from maintainers, and
cannot be pushed to unless a series of conditions are met). It's better if all
of your code is tested and documented, but we will work with you when receiving
the pull request anyways.
