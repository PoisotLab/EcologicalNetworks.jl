"""
Test a network property using randomizations based on a null model
"""
function test_network_property(N::DeterministicNetwork, f::Function; model::Function=null1, n=100, max=1000, test::Symbol=:greater)
    
    # Check the keyword arguments
    @assert model ∈ [null1, null2, null3in, null3out]
    @assert test ∈ [:greater, :smaller]

    # Generate the networks
    S = nullmodel(model(N), n=n, max=max)

    # Apply the function to the model
    d = pmap(f, S)

    # Get the empirical value
    v0 = f(N)

    # Count the number of positive cases
    hits = test == :greater ? sum(d .< v0) : sum(d .> v0)

    return hits/length(S)

end
