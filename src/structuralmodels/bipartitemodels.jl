

abstract type NetworkGenerator end 
Base.size(gen::NetworkGenerator) = gen.size

mutable struct ErdosRenyi{T<:Integer, PT<:AbstractFloat} <: NetworkGenerator  
    size::Tuple{T,T}
    probability::PT
end 
ErdosRenyi(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = ErdosRenyi(size, connectance)
ErdosRenyi(sz::T, X::NT) where {T <: Integer, NT<:Number} = ErdosRenyi((sz,sz), X)
ErdosRenyi(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = ErdosRenyi(sz, E/(sz[1]*sz[2]))
ErdosRenyi(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = ErdosRenyi(sz, C)




mutable struct PreferentialAttachment{T<:Integer} <: NetworkGenerator 
    size::Tuple{T,T}
    numedges::Integer
end 
PreferentialAttachment(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = PreferentialAttachment(size, connectance)
PreferentialAttachment(sz::T, X::NT) where {T <: Integer, NT<:Number} = PreferentialAttachment((sz,sz), X)
PreferentialAttachment(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = PreferentialAttachment(sz, E)
PreferentialAttachment(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = PreferentialAttachment(sz, Int(floor(C*sz[1]*sz[2])))



mutable struct CascadeModel{T<:Integer, FT<:AbstractFloat} <: NetworkGenerator 
    size::Tuple{T,T}
    connectance::FT
end 
CascadeModel(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = CascadeModel(size, connectance)
CascadeModel(sz::T, X::NT) where {T <: Integer, NT<:Number} = CascadeModel((sz,sz), X)
CascadeModel(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = CascadeModel(sz, E/(sz[1]*sz[2]))
CascadeModel(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = CascadeModel(sz, C)



mutable struct MinimumPotentialNicheModel{T<:Integer,FT<:AbstractFloat} <: NetworkGenerator 
    size::Tuple{T,T}
    connectance::FT
    forbiddenlinkprob::FT
end 
MinimumPotentialNicheModel(; size::T=30, connectance::FT=0.3, forbiddenlinkprob=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = MinimumPotentialNicheModel(size, connectance,forbiddenlinkprob)
MinimumPotentialNicheModel(sz::T, X::NT, Y::NT) where {T <: Integer, NT<:Number} = MinimumPotentialNicheModel((sz,sz), X,Y)
MinimumPotentialNicheModel(sz::T, E::ET, flp::FT) where {T <: Tuple{Integer,Integer}, ET<:Integer, FT<:AbstractFloat} = MinimumPotentialNicheModel(sz, E/(sz[1]*sz[2]), flp)
MinimumPotentialNicheModel(sz::T, C::CT, flp::FT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat, FT<:AbstractFloat} = MinimumPotentialNicheModel(sz, C, flp)




mutable struct NicheModel{T<:Integer, FT<:AbstractFloat} <: NetworkGenerator 
    size::Tuple{T,T}
    connectance::FT
end 
NicheModel(; size::T=30, connectance::FT=0.3) where {T <: Union{Tuple{Integer}, Integer}, FT <: AbstractFloat} = NicheModel(size, connectance)
NicheModel(sz::T, X::NT) where {T <: Integer, NT<:Number} = NicheModel((sz,sz), X)
NicheModel(sz::T, E::ET) where {T <: Tuple{Integer,Integer}, ET<:Integer} = NicheModel(sz,E/(sz[1]*sz[2]))
NicheModel(sz::T, C::CT) where {T <: Tuple{Integer,Integer}, CT<:AbstractFloat} = NicheModel(sz, C)






a = PreferentialAttachment((50,100), 0.1)
b = ErdosRenyi((30,50), 0.3)
c = NicheModel((30,50), 0.3)
d = MinimumPotentialNicheModel((100,50), 0.1, 0.3)
e = CascadeModel(50, 0.3)

rand(b)

function Base.rand(gen::NetworkGenerator) 
    size(gen)[1] == size(gen)[2] ? rand(gen, UnipartiteNetwork) : rand(gen, BipartiteNetwork)
end

function Base.rand(generator::NetworkGenerator, ::Type{T}) where {T <: AbstractEcologicalNetwork}    
    return _generate!(generator, T(zeros(Bool, size(generator)))) 
end


function Base.rand(generator::NetworkGenerator, target::T) where {T <: BipartiteNetwork} 
    size(generator)[1] == size(generator)[2] || @error "can't generate a unipartite networks with unequal dimensions"
    return _generate!(generator, target) 
end


function _generate!(gen::ErdosRenyi, target::T) where {T <: BipartiteNetwork}
    adjmat = bipartite_erdosrenyi(size(gen)..., gen.probability)
    target.edges = adjmat
    return target
end

function _generate!(gen::PreferentialAttachment, target::T) where {T <: BipartiteNetwork}
    adjmat = bipartite_preferentialattachment(size(gen)..., gen.numedges)
    target.edges = adjmat
    return target
end





"""
    bipartite_erdosrenyi(U, V, p; iterations = 10000)
    
    U -> number of nodes in bottom set
    V -> number of nodes in top set
    p -> probability of any edge occuring
"""

function bipartite_erdosrenyi(U,V,p)
    adjacency_matrix = zeros(Bool,U,V);

    for u in 1:U, v in 1:V
        adjacency_matrix[u,v] = rand() < p
    end
    return adjacency_matrix
end


"""
bipartite_preferentialattachment(T, B, E::Int; m::Int)

    Filho and O'Neale 2019, based on the unipartite preferential attachment
    model from Barabasi 
    
    T -> num in set of nodes top set
    B -> number of nodes in bottom set
    E -> number of edges 
    m -> number of edges to add at each iteraction
"""
function bipartite_preferentialattachment(T::IT, B::IT, E::IT) where {IT <: Integer}
    adjacency_matrix = zeros(Bool, T, B);
    adjacency_matrix[1,1] = 1

    numrounds = T+B;
    newedgesperround::Int32 = floor(E / (T+B));
    t,b, roundct = 1, 1, 1
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

    return adjacency_matrix
end

"""
    bipartite_degreedist(T,B,λ)

    Generates a bipartite network with `T` and `B` nodes in each
    partition, and draws the degree of each node in `T` from a Poisson
    distribution with mean `λ`. As T,B -> infinity, 
    the degree dist of T and B converge.
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
    return adjacency_matrix
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
    return adjacency_matrix
end


"""
a = bipartite_blockmodel(rand(100,75))
a = bipartite_degreedist(2000, 2500, 0.3)
a = bipartite_erdosrenyi(1000, 2000, 0.3)

a = bipartite_preferentialattachment(100, 75, 1400)


I = initial(BipartiteInitialLayout, a)
position!(NestedBipartiteLayout(0.4), I, a)
plot(I, a, la=0.05, aspectratio=1)
scatter!(I, a, bipartite=true)


histogram([η(bipartite_degreedist(30, 25, 0.3)) for i in 1:1000], label="degree dis")
histogram!([η(bipartite_erdosrenyi(30, 25, 0.3)) for i in 1:1000], label="erdos renyi")
histogram!([η(bipartite_preferentialattachment(30,25,0.3)) for i in 1:1000], label="pref attach")


bm = zeros(30,25)
bm[1:5, 1:5] .= 1
bm[6:10, 10:20] .= 2
bm[11:30, 20:25] .= 3
heatmap(bm)

histogram!([η(bipartite_blockmodel(bm)) for i in 1:1000], label="block model")
"""