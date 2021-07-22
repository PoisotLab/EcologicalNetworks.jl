
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
bipartite_preferentialattachment(T, B, E::Int; m::Int)

    Filho and O'Neale 2019
    
    T -> num in set of nodes top set
    B -> number of nodes in bottom set
    E -> number of edges 
    m -> number of edges to add at each iteraction
"""
function bipartite_preferentialattachment(T::IT, B::IT, C::FT; m = 2) where {IT <: Integer, FT<: AbstractFloat}
    totaledges = Int(floor(C*(T*B)))
    return bipartite_preferentialattachment(T,B, totaledges)
end

function bipartite_preferentialattachment(T::IT, B::IT, E::IT) where {IT <: Integer}
    adjacency_matrix = zeros(Bool, T, B);
    adjacency_matrix[1,1] = 1

    numrounds = T+B;
    newedgesperround::Int32 = floor(E / (T+B));
    t,b, roundct = 1,1, 1
    while roundct < numrounds
        if t <= T 
            b_degree = [sum(adjacency_matrix[:,b]) for b in 1:B] 
            newedgelocationdist = b_degree ./ sum(b_degree)

            for e in 1:newedgesperround
                b_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t, b_target] = 1
            end
            t += 1
        end

        if b <= B  
            t_degree = [sum(adjacency_matrix[t,:]) for t in 1:T] 
            newedgelocationdist = t_degree ./ sum(t_degree)

            for e in 1:newedgesperround
                t_target = rand(Categorical(newedgelocationdist))
                adjacency_matrix[t_target, b] = 1
            end
            b += 1
        end
        roundct = t + b
    end

    return BipartiteNetwork(adjacency_matrix)
end

"""
    bipartite_degreedist(T,B,λ)

    Generates a bipartite network with `T` and `B` nodes in each
    partition, and draws the degree of each node in `T` from a Poisson
    distribution with mean `λ`. As T,B -> infinity, 
    the degree dist of U and V converge.
"""
function bipartite_degreedist(T::IT, B::IT, C::FT) where {IT <: Integer, FT <: AbstractFloat}
    totaledges = C*(T*B)
    λ = totaledges/(T+B)
    return bipartite_degreedist(T, B; λ=λ)
end

function bipartite_degreedist(T::IT, B::IT; λ::FT = 3) where {IT <: Integer, FT <: AbstractFloat}
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

"""
a = bipartite_blockmodel(rand(100,75))
a = bipartite_degreedist(30, 25, 14)
a = bipartite_erdosrenyi(30, 20, 0.3)


a = bipartite_preferentialattachment(100, 75, 1400)
I = initial(BipartiteInitialLayout, a)
position!(NestedBipartiteLayout(0.4), I, a)
plot(I, a, la=0.05, aspectratio=1)
scatter!(I, a, bipartite=true)


histogram([η(bipartite_degreedist(30, 25, 0.3)) for i in 1:1000], label="degree dis")
histogram!([η(bipartite_erdosrenyi(30, 25, 0.3)) for i in 1:1000], label="erdos renyi")
histogram!([η(bipartite_preferentialattachment(30,25,0.3)) for i in 1:1000], label="pref attach")
histogram!([η(bipartite_blockmodel(rand(30,25))) for i in 1:1000], label="block model")
"""