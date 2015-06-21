# ProbabilisticNetwork

## Exported

---

<a id="method__q.1" class="lexicon_definition"></a>
#### Q(A::Array{Float64, 2}, L::Array{Int64, 1}) [¶](#method__q.1)
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a matrix and a list of
module labels.


*source:*
[ProbabilisticNetwork/src/./modularity.jl:28](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

---

<a id="method__q.2" class="lexicon_definition"></a>
#### Q(P::Partition) [¶](#method__q.2)
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a `Partition` object, and
update the object in the proccess.


*source:*
[ProbabilisticNetwork/src/./modularity.jl:46](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

---

<a id="method__qr.1" class="lexicon_definition"></a>
#### Qr(A::Array{Float64, 2}, L::Array{Int64, 1}) [¶](#method__qr.1)
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a  a matrix and a list of module
labels. Realized modularity takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.


*source:*
[ProbabilisticNetwork/src/./modularity.jl:64](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

---

<a id="method__qr.2" class="lexicon_definition"></a>
#### Qr(P::Partition) [¶](#method__qr.2)
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a `Partition` object.


*source:*
[ProbabilisticNetwork/src/./modularity.jl:79](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

---

<a id="method__a_var.1" class="lexicon_definition"></a>
#### a_var(p::Array{Float64, N}) [¶](#method__a_var.1)
Variance of a series of additive Bernoulli events

f(p): ∑(p(1-p))


*source:*
[ProbabilisticNetwork/src/./proba_utils.jl:63](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./proba_utils.jl)

---

<a id="method__betadiversity.1" class="lexicon_definition"></a>
#### betadiversity(A::Array{Float64, 2}, B::Array{Float64, 2}) [¶](#method__betadiversity.1)
 Measure the expected network similarity

Note that this is only meaningful to apply this function when the two matrices
have the same species at the same position! If this is note the case, a
`BoundsError` will be thrown.

This function will return a `BetaSet`, which is then used by the function to
actually measure the beta-diversity. This package uses the approach of Koleff et a. (2003).

**References**

1. Koleff, P., Gaston, K. J. and Lennon, J. J. (2003), Measuring beta diversity
for presence–absence data. Journal of Animal Ecology, 72: 367–382. doi:
10.1046/j.1365-2656.2003.00710.x



*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:40](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__centrality_katz.1" class="lexicon_definition"></a>
#### centrality_katz(A::Array{Float64, 2}) [¶](#method__centrality_katz.1)
 Measures Katz's centrality for each node in a unipartite network.

**Keyword arguments**

- `a` (def. 0.1), the weight of each subsequent connection
- `k` (def. 5), the maximal path length considered


*source:*
[ProbabilisticNetwork/src/./centrality.jl:10](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./centrality.jl)

---

<a id="method__connectance.1" class="lexicon_definition"></a>
#### connectance(A::Array{Float64, 2}) [¶](#method__connectance.1)
 Expected connectance for a probabilistic matrix, measured as the number
of expected links, divided by the size of the matrix.


*source:*
[ProbabilisticNetwork/src/./connectance.jl:15](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./connectance.jl)

---

<a id="method__connectance_var.1" class="lexicon_definition"></a>
#### connectance_var(A::Array{Float64, 2}) [¶](#method__connectance_var.1)
 Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.


*source:*
[ProbabilisticNetwork/src/./connectance.jl:23](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./connectance.jl)

---

<a id="method__count_motifs.1" class="lexicon_definition"></a>
#### count_motifs(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__count_motifs.1)
 Motif counter

This function will go through all k-permutations of `A` to measure the
probability of each induced subgraph being an instance of the motif given by
`m` (the square adjacency matrix of the motif, with 0 and 1).



*source:*
[ProbabilisticNetwork/src/./motifs.jl:37](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="method__degree.1" class="lexicon_definition"></a>
#### degree(A::Array{Float64, 2}) [¶](#method__degree.1)
 Expected degree


*source:*
[ProbabilisticNetwork/src/./degree.jl:14](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./degree.jl)

---

<a id="method__degree_in.1" class="lexicon_definition"></a>
#### degree_in(A::Array{Float64, 2}) [¶](#method__degree_in.1)
 Expected number of ingoing degrees


*source:*
[ProbabilisticNetwork/src/./degree.jl:8](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./degree.jl)

---

<a id="method__degree_out.1" class="lexicon_definition"></a>
#### degree_out(A::Array{Float64, 2}) [¶](#method__degree_out.1)
 Expected number of outgoing degrees


*source:*
[ProbabilisticNetwork/src/./degree.jl:2](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./degree.jl)

---

<a id="method__free_species.1" class="lexicon_definition"></a>
#### free_species(A::Array{Float64, 2}) [¶](#method__free_species.1)
 Expected number of species with no interactions

This function will be applied on the *unipartite* version of the network. Note
that the functions `species_ |predecessors` will work on bipartite networks, but
the unipartite situation is more general.



*source:*
[ProbabilisticNetwork/src/./free_species.jl:31](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./free_species.jl)

---

<a id="method__gaston.1" class="lexicon_definition"></a>
#### gaston(S::BetaSet) [¶](#method__gaston.1)
 Gaston measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:71](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__harrison.1" class="lexicon_definition"></a>
#### harrison(S::BetaSet) [¶](#method__harrison.1)
 Harrison measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:96](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__hartekinzig.1" class="lexicon_definition"></a>
#### hartekinzig(S::BetaSet) [¶](#method__hartekinzig.1)
 Harte-Kinzig measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:91](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__i_esp.1" class="lexicon_definition"></a>
#### i_esp(p::Float64) [¶](#method__i_esp.1)
Expected value of a single Bernoulli event

Simply f(p): p


*source:*
[ProbabilisticNetwork/src/./proba_utils.jl:37](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./proba_utils.jl)

---

<a id="method__i_var.1" class="lexicon_definition"></a>
#### i_var(p::Float64) [¶](#method__i_var.1)
Variance of a single Bernoulli event

f(p): p(1-p)


*source:*
[ProbabilisticNetwork/src/./proba_utils.jl:50](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./proba_utils.jl)

---

<a id="method__jaccard.1" class="lexicon_definition"></a>
#### jaccard(S::BetaSet) [¶](#method__jaccard.1)
 Jaccard measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:66](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__lande.1" class="lexicon_definition"></a>
#### lande(S::BetaSet) [¶](#method__lande.1)
 Lande measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:81](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__links.1" class="lexicon_definition"></a>
#### links(A::Array{Float64, 2}) [¶](#method__links.1)
 Expected number of links for a probabilistic matrix


*source:*
[ProbabilisticNetwork/src/./connectance.jl:2](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./connectance.jl)

---

<a id="method__links_var.1" class="lexicon_definition"></a>
#### links_var(A::Array{Float64, 2}) [¶](#method__links_var.1)
 Expected variance of the number of links for a probabilistic matrix


*source:*
[ProbabilisticNetwork/src/./connectance.jl:8](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./connectance.jl)

---

<a id="method__m_var.1" class="lexicon_definition"></a>
#### m_var(p::Array{Float64, N}) [¶](#method__m_var.1)
Variance of a series of multiplicative Bernoulli events


*source:*
[ProbabilisticNetwork/src/./proba_utils.jl:72](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./proba_utils.jl)

---

<a id="method__make_bernoulli.1" class="lexicon_definition"></a>
#### make_bernoulli(A::Array{Float64, 2}) [¶](#method__make_bernoulli.1)
Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 with
probability A(i,j).


*source:*
[ProbabilisticNetwork/src/./matrix_utils.jl:22](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./matrix_utils.jl)

---

<a id="method__make_binary.1" class="lexicon_definition"></a>
#### make_binary(A::Array{Float64, 2}) [¶](#method__make_binary.1)
Returns the adjacency/incidence matrix from a probability matrix

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is greater than 0.


*source:*
[ProbabilisticNetwork/src/./matrix_utils.jl:73](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./matrix_utils.jl)

---

<a id="method__make_threshold.1" class="lexicon_definition"></a>
#### make_threshold(A::Array{Float64, 2}, k::Float64) [¶](#method__make_threshold.1)
Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is > `k`. This is probably unwise to use this function since this
practice is of questionnable relevance, but it is included for the sake of
exhaustivity.

`k` must be in [0;1[.


*source:*
[ProbabilisticNetwork/src/./matrix_utils.jl:56](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./matrix_utils.jl)

---

<a id="method__make_unipartite.1" class="lexicon_definition"></a>
#### make_unipartite(A::Array{Float64, 2}) [¶](#method__make_unipartite.1)
Transforms a bipartite network into a unipartite network

Note that this function returns an asymetric unipartite network.


*source:*
[ProbabilisticNetwork/src/./matrix_utils.jl:7](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./matrix_utils.jl)

---

<a id="method__motif.1" class="lexicon_definition"></a>
#### motif(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__motif.1)
 Expected number of a given motif 

*source:*
[ProbabilisticNetwork/src/./motifs.jl:59](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="method__motif_p.1" class="lexicon_definition"></a>
#### motif_p(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__motif_p.1)
 Probability that a group of species form a given motif 

*source:*
[ProbabilisticNetwork/src/./motifs.jl:21](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="method__motif_v.1" class="lexicon_definition"></a>
#### motif_v(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__motif_v.1)
 Variance that a group of species form a given motif 

*source:*
[ProbabilisticNetwork/src/./motifs.jl:26](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="method__motif_var.1" class="lexicon_definition"></a>
#### motif_var(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__motif_var.1)
 Expected variance of a given motif 

*source:*
[ProbabilisticNetwork/src/./motifs.jl:64](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="method__nestedness.1" class="lexicon_definition"></a>
#### nestedness(A::Array{Float64, 2}) [¶](#method__nestedness.1)
Nestedness of a matrix, using the Bastolla et al. (XXXX) measure

Returns three values:

- nestedness of the entire matrix
- nestedness of the columns
- nestedness of the rows


*source:*
[ProbabilisticNetwork/src/./nestedness.jl:30](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nestedness.jl)

---

<a id="method__nestedness_axis.1" class="lexicon_definition"></a>
#### nestedness_axis(A::Array{Float64, 2}) [¶](#method__nestedness_axis.1)
Nestedness of a single axis (called internally by `nestedness`)


*source:*
[ProbabilisticNetwork/src/./nestedness.jl:2](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nestedness.jl)

---

<a id="method__nodiag.1" class="lexicon_definition"></a>
#### nodiag(A::Array{Float64, 2}) [¶](#method__nodiag.1)
Sets the diagonal to 0

Returns a copy of the matrix A, with  the diagonal set to 0. Will fail if the
matrix is not square.


*source:*
[ProbabilisticNetwork/src/./matrix_utils.jl:38](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./matrix_utils.jl)

---

<a id="method__null1.1" class="lexicon_definition"></a>
#### null1(A::Array{Float64, 2}) [¶](#method__null1.1)
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.


*source:*
[ProbabilisticNetwork/src/./nullmodels.jl:7](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nullmodels.jl)

---

<a id="method__null2.1" class="lexicon_definition"></a>
#### null2(A::Array{Float64, 2}) [¶](#method__null2.1)
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


*source:*
[ProbabilisticNetwork/src/./nullmodels.jl:46](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nullmodels.jl)

---

<a id="method__null3in.1" class="lexicon_definition"></a>
#### null3in(A::Array{Float64, 2}) [¶](#method__null3in.1)
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.


*source:*
[ProbabilisticNetwork/src/./nullmodels.jl:34](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nullmodels.jl)

---

<a id="method__null3out.1" class="lexicon_definition"></a>
#### null3out(A::Array{Float64, 2}) [¶](#method__null3out.1)
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.


*source:*
[ProbabilisticNetwork/src/./nullmodels.jl:20](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nullmodels.jl)

---

<a id="method__nullmodel.1" class="lexicon_definition"></a>
#### nullmodel(A::Array{Float64, 2}) [¶](#method__nullmodel.1)
 This function is a wrapper to generate replicated binary matrices from
a template probability matrix `A`.

If you use julia on more than one CPU, *i.e.* if you started it with `julia -p
k` where `k` is more than 1, this function will distribute each trial to one
worker. Which means that it's fast.

Note that you will get a warning if there are less networks created than have
been requested. Not also that this function generates networks, but do not check
that their distribution is matching what you expect. Simulated annealing
routines will be part of a later release.

**Keyword arguments**

- `n` (def. 1000), number of replicates to generate
- `max` (def. 10000), number of trials to make



*source:*
[ProbabilisticNetwork/src/./nullmodels.jl:78](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./nullmodels.jl)

---

<a id="method__number_of_paths.1" class="lexicon_definition"></a>
#### number_of_paths(A::Array{Float64, 2}) [¶](#method__number_of_paths.1)
 Measures the expected number of paths in a probabilistic network

**Keyword arguments**

- `n` (def. 2), the path length


*source:*
[ProbabilisticNetwork/src/./paths.jl:9](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./paths.jl)

---

<a id="method__propagate_labels.1" class="lexicon_definition"></a>
#### propagate_labels(A::Array{Float64, 2}, kmax::Int64, smax::Int64) [¶](#method__propagate_labels.1)
A **very** experimental label propagation method for probabilistic networks

This function is a take on the usual LP method for community detection. Instead
of updating labels by taking the most frequent in the neighbors, this algorithm
takes each interaction, and transfers the label across it with a probability
equal to the probability of the interaction. It is therefore *not* generalizable
for non-probabilistic networks.

The other pitfall is that there is a need to do a *large* number of iterations
to get to a good partition. This method is also untested.


*source:*
[ProbabilisticNetwork/src/./modularity.jl:98](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

---

<a id="method__ruggiero.1" class="lexicon_definition"></a>
#### ruggiero(S::BetaSet) [¶](#method__ruggiero.1)
 Ruggiero measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:86](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__sorensen.1" class="lexicon_definition"></a>
#### sorensen(S::BetaSet) [¶](#method__sorensen.1)
 Sorensen measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:61](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__species_has_no_predecessors.1" class="lexicon_definition"></a>
#### species_has_no_predecessors(A::Array{Float64, 2}) [¶](#method__species_has_no_predecessors.1)
 Probability that a species has no predecessors 

*source:*
[ProbabilisticNetwork/src/./free_species.jl:1](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./free_species.jl)

---

<a id="method__species_has_no_successors.1" class="lexicon_definition"></a>
#### species_has_no_successors(A::Array{Float64, 2}) [¶](#method__species_has_no_successors.1)
 Probability that a species has no successors 

*source:*
[ProbabilisticNetwork/src/./free_species.jl:7](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./free_species.jl)

---

<a id="method__species_is_free.1" class="lexicon_definition"></a>
#### species_is_free(A::Array{Float64, 2}) [¶](#method__species_is_free.1)
 Probability that a species has no links

This will return a vector, where the *i*th element is the probability that
species *i* has no interaction. Note that this is only meaningful for unipartite
networks.



*source:*
[ProbabilisticNetwork/src/./free_species.jl:19](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./free_species.jl)

---

<a id="method__whittaker.1" class="lexicon_definition"></a>
#### whittaker(S::BetaSet) [¶](#method__whittaker.1)
 Whittaker measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:56](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="method__williams.1" class="lexicon_definition"></a>
#### williams(S::BetaSet) [¶](#method__williams.1)
 Williams measure of beta-diversity 

*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:76](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="type__partition.1" class="lexicon_definition"></a>
#### Partition [¶](#type__partition.1)
Type to store a community partition

This type has three elements:

- `A`, the probability matrix
- `L`, the array of (integers) module labels
- `Q`, if needed, the modularity value



*source:*
[ProbabilisticNetwork/src/./modularity.jl:13](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./modularity.jl)

## Internal

---

<a id="method__motif_internal.1" class="lexicon_definition"></a>
#### motif_internal(A::Array{Float64, 2}, m::Array{Float64, 2}) [¶](#method__motif_internal.1)
 Internal motif calculations

The two arguments are `A` the adjacency matrix (probabilistic) and `m` the motif
adjacency matrix (0.0 or 1.0 only). The two matrices must have the same size.
The function returns a *vectorized* probability of each interaction being in the
right state for the motif, *i.e.* P if m is 1, and 1 - P if m is 0.



*source:*
[ProbabilisticNetwork/src/./motifs.jl:8](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./motifs.jl)

---

<a id="type__betaset.1" class="lexicon_definition"></a>
#### BetaSet [¶](#type__betaset.1)
 Partition of network similarity

The sets are, respectively

- `a`, expected number of common interactions
- `b`, expected number of interactions unique to B
- `c`, expected number of interactions unique to A

Note that *all* values are `Float64`, since when dealing with probabilistic
events, the expected cardinality of each set is not integers.



*source:*
[ProbabilisticNetwork/src/./betadiversity.jl:12](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./betadiversity.jl)

---

<a id="macro___checkprob.1" class="lexicon_definition"></a>
#### @checkprob(p) [¶](#macro___checkprob.1)
Quite crude way of checking that a number is a probability

The two steps are

1. The number should be of the `Float64` type -- if not, will yield a `TypeError`
2. The number should belong to [0,1] -- if not, will throw a `DomainError`



*source:*
[ProbabilisticNetwork/src/./proba_utils.jl:15](file:///home/tpoisot/.julia/v0.3/ProbabilisticNetwork/src/./proba_utils.jl)

