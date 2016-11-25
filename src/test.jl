"""
Type to store the output of a permutation-based test

The fields are

1. `pval` -- the test p-value
2. `test` -- the type of test (`:smaller` or `:greater`)
3. `v0` -- the measure of the empirical network
4. `n` -- the number of randomized netorks used
5. `hits` -- the number of randomized network matching the test condition
6. `z` -- the *z*-scores of the statistics for each randomized network

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
Test a network property using randomizations based on a null model, from a
pre-existing collection of networks.

Keyword argument: `test` (`:smaller` or `:greater`)
"""
function test_network_property(N::DeterministicNetwork, f::Function, S::Array{DeterministicNetwork, 1}; test::Symbol=:greater)
    
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

"""
Test a network property using randomizations based on a null model, by
specifying the number of replicates and the model to use.
"""
function test_network_property(N::DeterministicNetwork, f::Function; model::Function=null1, n=100, max=1000, test::Symbol=:greater)
    
    # Check the keyword arguments
    @assert model ∈ [null1, null2, null3in, null3out]

    # Generate the networks
    S = nullmodel(model(N), n=n, max=max)

    return test_network_property(N, f, S, test=test)

end

