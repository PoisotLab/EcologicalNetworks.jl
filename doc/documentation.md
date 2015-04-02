# ProbabilisticNetwork

## Exported
---

#### null1(A::Array{Float64, 2})
Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:7](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/f6fb66d794890859faf38197ad9de83971cef6e8/src/./nullmodels.jl#L7)

---

#### null2(A::Array{Float64, 2})
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:46](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/f6fb66d794890859faf38197ad9de83971cef6e8/src/./nullmodels.jl#L46)

---

#### null3in(A::Array{Float64, 2})
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:34](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/f6fb66d794890859faf38197ad9de83971cef6e8/src/./nullmodels.jl#L34)

---

#### null3out(A::Array{Float64, 2})
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:20](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/f6fb66d794890859faf38197ad9de83971cef6e8/src/./nullmodels.jl#L20)

---

#### nullmodel(A::Array{Float64, 2})
 This function is a wrapper to generate replicated binary matrices from
a template probability matrix `A`.

**Keyword arguments**

- `n` (def. 1000), number of replicates to generate
- `max` (def. 10000), number of trials to make



**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:69](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/f6fb66d794890859faf38197ad9de83971cef6e8/src/./nullmodels.jl#L69)


