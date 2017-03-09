"""
**Output of a permutation-based test**

- `pval` -- the test p-value
- `test` -- the type of test (`:smaller` or `:greater`)
- `v0` -- the measure of the empirical network
- `n` -- the number of randomized networks used
- `hits` -- the number of randomized network matching the test condition
- `z` -- the *z*-scores of the statistics for each randomized network
"""
type NetworkTestOutput
  pval::Float64
  test::Symbol
  v0::Float64
  n::Int64
  hits::Int64
  z::Array{Float64, 1}
end

"""
**Null Hypothesis Significance Testing**

    test_network_property(N::EcoNetwork, f, S; test::Symbol=:greater)

Test whether the observed value (through applying a function `f`) on an
empirical network `N` differs from the distribution derived from measuring the
same value on a collection of randomized networks `S`. `S` is an array of
networks of the same type as `N`.

There are two possible values for the `test` keyword argument: `:greater` and
`:smaller`. The test is one-tailed. The results are returned as a
`NetworkTestOutput` object (see `?EcologicalNetwork.NetworkTestOutput` for the
complete edocumentation).

The *p*-value (`pval`) is measured by counting the proportion of networks with a larger
(resp. smaller) value of the measure than the original network, as in normal
permutation tests.

The original value of the measure is given (`v0`), as well as the *z*-scores
(`z`) of all randomized networks.
"""
function test_network_property(N::EcoNetwork, f, S; test::Symbol=:greater)

  # Check the keyword arguments
  @assert test ∈ [:greater, :smaller]

  # Apply the function to the model
  d = map(Float64, pmap(f, S))

  # Get the empirical value
  v0 = f(N)

  # Count the number of positive cases
  hits = test == :greater ? sum(d .> v0) : sum(d .< v0)

  return NetworkTestOutput(
    hits/length(S),      # p value
    test,                # test type
    v0,                  # measured value
    length(S),           # true sample size
    hits,                # number of hits
    (d .- v0)./std(d)    # z-values
  )

end
