"""
    bipartite_erdosrenyi(U, V, p; iterations = 10000)

    Filho and O'Neale 2019
    
    U -> num in set of nodes bottom set
    V -> number of nodes in top set
    p -> probability of any edge occuring
"""

function bipartite_erdosrenyi(U,V,p)
    adjacency_matrix = zeros(Bool,U,V);

    for u in 1:U, v in 1:V
        adjacency_matrix[u,v] = rand() < p
    end
    return BipartiteNetwork(adjacency_matrix)
end


"""
bipartite_preferentialattachment(U, V, E::Int; m::Int,iterations = 10000)

    Filho and O'Neale 2019
    
    U -> num in set of nodes bottom set
    V -> number of nodes in top set
    E -> number of edges 
"""
function bipartite_preferentialattachment(U,V,E)
    adjacency_matrix = zeros(U,V);

    for u in 2:U, v in 2:V 

    end
    for e in 2:E
        u = rand(1:U)
        k_v = [adjacency_matrix[:, v] for v in 1:V]
        prob_uv = k_v./sum(k_v)
        v = rand(Categorical(prob_uv))
        adjacency_matrix[u,v]
    end
    return adjacency_matrix
end

"""
    bipartite_degreedist(T,B,λ)

    Generates a bipartite network with `T` and `B` nodes in each
    partition, and draws the degree of each node in `T` from a Poisson
    distribution with mean `λ`. As T,B -> infinity, 
    the degree dist of U and V converge.
"""
function bipartite_degreedist(T,B,λ)
    adjacency_matrix = zeros(Bool, T,B);

    for t in 1:T
        k_t = min(rand(Poisson(λ)), T)  
        attach = sample(collect(1:B), k_t, replace=false)
        for b in attach 
            adjacency_matrix[t,b] = 1
        end
    end
    return BipartiteNetwork(adjacency_matrix)
end


"""
    bipartite_blockmodel(M)

    Generates a bipartite network from a matrix `M` which gives the 
    probability M_ij that an edge exists between node `i` and `j`, where
    `i` and `j` are in different partitions.  
"""
function bipartite_blockmodel(M::AbstractArray{FT,2}) where {FT <: AbstractFloat}
    adjacency_matrix = map(x ->rand() < x,  M)
    T,B = size(adjacency_matrix)
    return BipartiteNetwork(adjacency_matrix, ["t$i" for i in 1:T], ["b$i" for i in 1:B])
end


a = bipartite_blockmodel(rand(100,75))
a = bipartite_degreedist(30, 25, 14)
a = bipartite_erdosrenyi(30, 20, 0.3)

I = initial(BipartiteInitialLayout, a)
position!(NestedBipartiteLayout(0.4), I, a)
plot(I, a, la=0.1, aspectratio=1)
scatter!(I, a, bipartite=true)


histogram([η(bipartite_degreedist(30, 25, 5)) for i in 1:1000], label="degree dis")
histogram!([η(bipartite_erdosrenyi(30, 25, 0.3)) for i in 1:1000], label="erdos renyi")
histogram!([η(bipartite_blockmodel(rand(30,25))) for i in 1:1000], label="block model")

