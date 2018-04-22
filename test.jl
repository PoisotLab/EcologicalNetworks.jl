# Test with figures

using Luxor

include("src/EcologicalNetwork.jl")
using EcologicalNetwork

# Force atlas
N = fonseca_ganade_1996()

L = 1.0
Kr = 0.4
Ks = 0.4
δt = 0.01

# The infos for every nodes are a dictionary
nodes = Dict([s => Dict([:x=>rand()*5.0, :y=>rand()*5.0, :fx=>0.0, :fy=>0.0]) for s in species(N)])

for step in 1:2000
    # Repulsion between all pairs
    for s1 in species(N)[1:(end-1)]
        index_of_s1 = first(find(species(N).==s1))
        for s2 in species(N)[(index_of_s1+1):end]
            dx, dy = nodes[s1][:x]-nodes[s2][:x], nodes[s1][:y]-nodes[s2][:y]
            distance_squared = dx*dx + dy*dy
            distance = sqrt(distance_squared)
            force = Kr / distance_squared
            fx = force * dx / distance
            fy = force * dy / distance
            nodes[s1][:fx] -= fx
            nodes[s2][:fx] += fx
            nodes[s1][:fy] -= fy
            nodes[s2][:fy] += fy
        end
    end

    # Spring force between adjacent pairs
    for s1 in species(N)[1:(end-1)]
        s1_neighbors = eltype(species(N))[]
        if s1 in species(N, 1)
            s1_in_neighbors = filter(s2 -> has_interaction(N, s1, s2), species(N,2))
            append!(s1_neighbors, s1_in_neighbors)
        end
        if s1 in species(N, 2)
            s1_out_neighbors = filter(s2 -> has_interaction(N, s2, s1), species(N,1))
            append!(s1_neighbors, s1_out_neighbors)
        end
        #index_of_s1 = first(find(species(N).==s1))
        for s2 in s1_neighbors
            #index_of_s1 = first(find(species(N).==s2))
            #if index_of_s1 < index_of_s2
            dx, dy = nodes[s1][:x]-nodes[s2][:x], nodes[s1][:y]-nodes[s2][:y]
            distance_squared = dx*dx + dy*dy
            distance = sqrt(distance_squared)
            force = Ks * (distance-L)
            fx = force * dx / distance
            fy = force * dy / distance
            nodes[s1][:fx] -= fx
            nodes[s2][:fx] += fx
            nodes[s1][:fy] -= fy
            nodes[s2][:fy] += fy
        end
    end

    for s in species(N)
        dx = δt * nodes[s][:fx]
        dy = δt * nodes[s][:fy]
        displacement = dx*dx + dy*dy
        nodes[s][:x] += dx
        nodes[s][:y] += dy
        nodes[s][:fx] = 0.0
        nodes[s][:fy] = 0.0
    end
end

xs = [x[:x] for (k,x) in nodes]
ys = [x[:y] for (k,x) in nodes]

w = maximum(xs)-minimum(xs)
h = maximum(ys)-minimum(ys)

scaling = 5

xm = mean(xs)
ym = mean(ys)

points = Dict([
    s => Point((nodes[s][:x]-xm)*scaling, (nodes[s][:y]-ym)*scaling) for s in species(N)
    ])

Drawing(round(w*scaling*2.1, 0), round(h*scaling*2.1,0), "test.png")
origin()
background("#ffffff")
sethue("#333")

for s1 in species(N,1)
    for s2 in species(N,2)
        if has_interaction(N, s1, s2)
            line(points[s1], points[s2], :stroke)
        end
    end
end

for s in species(N)
    if typeof(N) <: AbstractBipartiteNetwork
        if s in species(N,1)
            sethue("#ccc")
        else
            sethue("#c3c")
        end
    else
        sethue("#ccc")
    end
    circle(points[s], 5, :fill)
    sethue("#333")
    circle(points[s], 5, :stroke)
end

finish()
