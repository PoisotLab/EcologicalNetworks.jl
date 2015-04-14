# ProbabilisticNetwork

## Exported
---

#### Q(A::Array{Float64, 2}, L::Array{Int64, 1})
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a matrix and a list of
module labels.


**source:**
[ProbabilisticNetwork/src/./modularity.jl:28](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L28)

---

#### Q(P::ProbabilisticNetwork.Partition)
Q -- a measure of modularity

This measures Barber's bipartite modularity based on a `Partition` object, and
update the object in the proccess.


**source:**
[ProbabilisticNetwork/src/./modularity.jl:46](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L46)

---

#### Qr(A::Array{Float64, 2}, L::Array{Int64, 1})
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a  a matrix and a list of module
labels. Realized modularity takes values in the [0;1] interval, and is the
proportion of interactions established *within* modules.

Note that in some situations, `Qr` can be *lower* than 0. This reflects a
partition in which more links are established between than within modules.


**source:**
[ProbabilisticNetwork/src/./modularity.jl:64](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L64)

---

#### Qr(P::ProbabilisticNetwork.Partition)
Qr -- a measure of realized modularity

Measures Poisot's realized modularity, based on a `Partition` object.


**source:**
[ProbabilisticNetwork/src/./modularity.jl:79](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L79)

---

#### a_var(p::Array{Float64, N})
Variance of a series of additive Bernoulli events

f(p): ∑(p(1-p))


**source:**
[ProbabilisticNetwork/src/./proba_utils.jl:63](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./proba_utils.jl#L63)

---

#### centrality_katz(A::Array{Float64, 2})
 Measures Katz's centrality for each node in a unipartite network.

**Keyword arguments**

- `a` (def. 0.1), the weight of each subsequent connection
- `k` (def. 5), the maximal path length considered


**source:**
[ProbabilisticNetwork/src/./centrality.jl:10](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./centrality.jl#L10)

---

#### connectance(A::Array{Float64, 2})
 Expected connectance for a probabilistic matrix, measured as the number
of expected links, divided by the size of the matrix.


**source:**
[ProbabilisticNetwork/src/./connectance.jl:15](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./connectance.jl#L15)

---

#### connectance_var(A::Array{Float64, 2})
 Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.


**source:**
[ProbabilisticNetwork/src/./connectance.jl:23](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./connectance.jl#L23)

---

#### degree(A::Array{Float64, 2})
 Expected degree


**source:**
[ProbabilisticNetwork/src/./degree.jl:20](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./degree.jl#L20)

---

#### degree_in(A::Array{Float64, 2})
 Expected number of ingoing degrees


**source:**
[ProbabilisticNetwork/src/./degree.jl:14](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./degree.jl#L14)

---

#### degree_out(A::Array{Float64, 2})
 Expected number of outgoing degrees


**source:**
[ProbabilisticNetwork/src/./degree.jl:8](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./degree.jl#L8)

---

#### i_esp(p::Float64)
Expected value of a single Bernoulli event

Simply f(p): p


**source:**
[ProbabilisticNetwork/src/./proba_utils.jl:37](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./proba_utils.jl#L37)

---

#### i_var(p::Float64)
Variance of a single Bernoulli event

f(p): p(1-p)


**source:**
[ProbabilisticNetwork/src/./proba_utils.jl:50](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./proba_utils.jl#L50)

---

#### links(A::Array{Float64, 2})
 Expected number of links for a probabilistic matrix


**source:**
[ProbabilisticNetwork/src/./connectance.jl:2](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./connectance.jl#L2)

---

#### links_var(A::Array{Float64, 2})
 Expected variance of the number of links for a probabilistic matrix


**source:**
[ProbabilisticNetwork/src/./connectance.jl:8](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./connectance.jl#L8)

---

#### m_var(p::Array{Float64, N})
Variance of a series of multiplicative Bernoulli events


**source:**
[ProbabilisticNetwork/src/./proba_utils.jl:72](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./proba_utils.jl#L72)

---

#### make_bernoulli(A::Array{Float64, 2})
Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 with
probability A(i,j).


**source:**
[ProbabilisticNetwork/src/./matrix_utils.jl:22](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./matrix_utils.jl#L22)

---

#### make_binary(A::Array{Float64, 2})
Returns the adjacency/incidence matrix from a probability matrix

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is greater than 0.


**source:**
[ProbabilisticNetwork/src/./matrix_utils.jl:73](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./matrix_utils.jl#L73)

---

#### make_threshold(A::Array{Float64, 2}, k::Float64)
Generate a random 0/1 matrix from probabilities

Returns a matrix B of the same size as A, in which each element B(i,j) is 1 if
A(i,j) is > `k`. This is probably unwise to use this function since this
practice is of questionnable relevance, but it is included for the sake of
exhaustivity.

`k` must be in [0;1[.


**source:**
[ProbabilisticNetwork/src/./matrix_utils.jl:56](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./matrix_utils.jl#L56)

---

#### make_unipartite(A::Array{Float64, 2})
Transforms a bipartite network into a unipartite network

Note that this function returns an asymetric unipartite network.


**source:**
[ProbabilisticNetwork/src/./matrix_utils.jl:7](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./matrix_utils.jl#L7)

---

#### nestedness(A::Array{Float64, 2})
Nestedness of a matrix, using the Bastolla et al. (XXXX) measure

Returns three values:

- nestedness of the entire matrix
- nestedness of the columns
- nestedness of the rows


**source:**
[ProbabilisticNetwork/src/./nestedness.jl:36](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nestedness.jl#L36)

---

#### nestedness_axis(A::Array{Float64, 2})
Nestedness of a single axis (called internally by `nestedness`)


**source:**
[ProbabilisticNetwork/src/./nestedness.jl:5](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nestedness.jl#L5)

---

#### nodiag(A::Array{Float64, 2})
Sets the diagonal to 0

Returns a copy of the matrix A, with  the diagonal set to 0. Will fail if the
matrix is not square.


**source:**
[ProbabilisticNetwork/src/./matrix_utils.jl:38](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./matrix_utils.jl#L38)

---

#### null1(A::Array{Float64, 2})
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:7](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nullmodels.jl#L7)

---

#### null2(A::Array{Float64, 2})
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:46](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nullmodels.jl#L46)

---

#### null3in(A::Array{Float64, 2})
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:34](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nullmodels.jl#L34)

---

#### null3out(A::Array{Float64, 2})
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:20](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nullmodels.jl#L20)

---

#### nullmodel(A::Array{Float64, 2})
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



**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:78](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./nullmodels.jl#L78)

---

#### propagate_labels(A::Array{Float64, 2}, kmax::Int64, smax::Int64)
A **very** experimental label propagation method for probabilistic networks

This function is a take on the usual LP method for community detection. Instead
of updating labels by taking the most frequent in the neighbors, this algorithm
takes each interaction, and transfers the label across it with a probability
equal to the probability of the interaction. It is therefore *not* generalizable
for non-probabilistic networks.

The other pitfall is that there is a need to do a *large* number of iterations
to get to a good partition. This method is also untested.


**source:**
[ProbabilisticNetwork/src/./modularity.jl:98](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L98)

---

#### ProbabilisticNetwork.Partition
Type to store a community partition

This type has three elements:

- `A`, the probability matrix
- `L`, the array of (integers) module labels
- `Q`, if needed, the modularity value



**source:**
[ProbabilisticNetwork/src/./modularity.jl:13](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./modularity.jl#L13)

## Internal
---

#### @checkprob(p)
Quite crude way of checking that a number is a probability

The two steps are

1. The number should be of the `Float64` type -- if not, will yield a `TypeError`
2. The number should belong to [0,1] -- if not, will throw a `DomainError`



**signature:**
checkprob(p)

**source:**
[ProbabilisticNetwork/src/./proba_utils.jl:15](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/2250c7c442741dce22b76f0cd6eb91ecc1c29705/src/./proba_utils.jl#L15)


