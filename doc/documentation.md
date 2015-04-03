# ProbabilisticNetwork

## Exported
---

#### centrality_katz(A::Array{Float64, 2})
 Measures Katz's centrality for each node in a unipartite network.

**Keyword arguments**

- `a` (def. 0.1), the weight of each subsequent connection
- `k` (def. 5), the maximal path length considered


**source:**
[ProbabilisticNetwork/src/./centrality.jl:10](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./centrality.jl#L10)

---

#### connectance(A::Array{Float64, 2})
 Expected connectance for a probabilistic matrix, measured as the number
of expected links, divided by the size of the matrix.


**source:**
[ProbabilisticNetwork/src/./connectance.jl:15](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./connectance.jl#L15)

---

#### connectance_var(A::Array{Float64, 2})
 Expected variance of the connectance for a probabilistic matrix,
measured as the variance of the number of links divided by the squared size of
the matrix.


**source:**
[ProbabilisticNetwork/src/./connectance.jl:23](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./connectance.jl#L23)

---

#### links(A::Array{Float64, 2})
 Expected number of links for a probabilistic matrix


**source:**
[ProbabilisticNetwork/src/./connectance.jl:2](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./connectance.jl#L2)

---

#### links_var(A::Array{Float64, 2})
 Expected variance of the number of links for a probabilistic matrix


**source:**
[ProbabilisticNetwork/src/./connectance.jl:8](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./connectance.jl#L8)

---

#### null1(A::Array{Float64, 2})
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:7](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./nullmodels.jl#L7)

---

#### null2(A::Array{Float64, 2})
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:46](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./nullmodels.jl#L46)

---

#### null3in(A::Array{Float64, 2})
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:34](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./nullmodels.jl#L34)

---

#### null3out(A::Array{Float64, 2})
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:20](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./nullmodels.jl#L20)

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
[ProbabilisticNetwork/src/./nullmodels.jl:78](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/8b000e923a08f3bfccaeff17deca9ca5b5478628/src/./nullmodels.jl#L78)


