# Test with figures

using Luxor

include("src/EcologicalNetwork.jl")
using EcologicalNetwork

N = fonseca_ganade_1996()
N = thompson_townsend_catlins()
N = unipartitemotifs()[:S1]

# The infos for every nodes are a dictionary
nodes = Dict([species(N)[i] => i for i in 1:richness(N)])
angles = Dict([species(N)[i] => 0.0 for i in 1:richness(N)])

function circle_angle(p, N)
    return (p*2.0*π)/N
end

function angle_of_vector(x,y)
    hypotenuse = sqrt(x*x+y*y)
    θ = asin(y/hypotenuse)
    if x < 0.0
        θ = π - θ
    end
    if θ < 0.0
         θ += 2.0*π
    end
    return θ
end

for s1 in species(N)
    p1 = nodes[s1]
    sx = cos(circle_angle(p1, richness(N)))
    sy = sin(circle_angle(p1, richness(N)))
    if s1 in species(N,1)
        for s2 in species(N, 2)
            if has_interaction(N,s1,s2)
                p2 = nodes[s2]
                sx += cos(circle_angle(p2, richness(N)))
                sy += sin(circle_angle(p2, richness(N)))
            end
        end
    end
    if s1 in species(N,2)
        for s2 in species(N, 1)
            if has_interaction(N,s2,s1)
                p2 = nodes[s2]
                sx += cos(circle_angle(p2, richness(N)))
                sy += sin(circle_angle(p2, richness(N)))
            end
        end
    end
    angles[s1] = angle_of_vector(sx, sy)
end

nodes = Dict(zip(species(N), sortperm(collect(values(angles)))))
angles = Dict([s => circle_angle(v, richness(N)) for (s,v) in nodes])

r = 300.0

points = Dict([
    s => Point(r * cos(angles[s]), r * sin(angles[s])) for s in species(N)
    ])

Drawing(660, 660, "test.png")
origin()
background("#ffffff")
sethue("#333")

for s1 in species(N,1)
    for s2 in species(N,2)
        if has_interaction(N, s1, s2)
            line(points[s1], points[s2], :stroke)
            #arrow(points[s1], points[s2])
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
    circle(points[s], 8, :fill)
    sethue("#333")
    circle(points[s], 8, :stroke)
end

finish()
