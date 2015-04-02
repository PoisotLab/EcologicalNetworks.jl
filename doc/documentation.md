# ProbabilisticNetwork

## Exported
---

#### null1(A::Array{Float64, 2})
## Type I null model

Given a matrix `A`, `null1(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the connectance of `A`.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:9](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/fc3e16dd608472dfe126566e5547389da1735bd2/src/./nullmodels.jl#L9)

---

#### null2(A::Array{Float64, 2})
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:48](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/fc3e16dd608472dfe126566e5547389da1735bd2/src/./nullmodels.jl#L48)

---

#### null3in(A::Array{Float64, 2})
Given a matrix `A`, `null3in(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the in-degree
(number of predecessors) of each species, divided by the total number of
possible predecessors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:36](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/fc3e16dd608472dfe126566e5547389da1735bd2/src/./nullmodels.jl#L36)

---

#### null3out(A::Array{Float64, 2})
Given a matrix `A`, `null3out(A)` returns a matrix with the same dimensions,
where every interaction happens with a probability equal to the out-degree
(number of successors) of each species, divided by the total number of possible
successors.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:22](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/fc3e16dd608472dfe126566e5547389da1735bd2/src/./nullmodels.jl#L22)

---

#### nullmodel(A::Array{Float64, 2})
Given a matrix `A`, `null2(A)` returns a matrix with the same dimensions, where
every interaction happens with a probability equal to the degree of each
species.


**source:**
[ProbabilisticNetwork/src/./nullmodels.jl:67](https://github.com/PoisotLab/ProbabilisticNetwork.jl/tree/fc3e16dd608472dfe126566e5547389da1735bd2/src/./nullmodels.jl#L67)


