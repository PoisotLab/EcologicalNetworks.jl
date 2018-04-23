# Test with figures

using Luxor

include("src/EcologicalNetwork.jl")
using EcologicalNetwork

N = fonseca_ganade_1996()
#N = thompson_townsend_catlins()
#N = unipartitemotifs()[:S1]

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

for step in 1:500
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

    nodes = Dict(zip(keys(angles), sortperm(collect(values(angles)))))
    angles = Dict([s => circle_angle(v, richness(N)) for (s,v) in nodes])
end

r = 400.0

points = Dict([
    s => Point(r * cos(angles[s]), r * sin(angles[s])) for s in species(N)
    ])

begin
    Drawing(960, 960, "test.png")
    origin()
    background("#ffffff")
    sethue("#333")

    circle_center = Point(0.0, 0.0)

    for s1 in species(N,1)
        has_int = false
        for s2 in species(N,2)
            if has_interaction(N, s1, s2)
                #has_int = true
                p2, p1 = points[s1], points[s2]
                detp1p2 = (p1.x) * (p2.y) - (p2.x) * (p1.y) < 0
                if detp1p2
                    p1, p2 = points[s1], points[s2]
                end
                mid = midpoint(p1, p2)
                chord_length = sqrt((p1.x-p2.x)^2+(p1.y-p2.y)^2)
                adjacent_side = chord_length/(2*tan(π/6))
                dist_midpoint = sqrt(mid.x^2+mid.y^2)
                dist_adj = 1+adjacent_side/(adjacent_side+dist_midpoint)
                c = between(circle_center, mid, dist_adj)
                println(dist_adj, "  ", dist_midpoint)
                #=sethue("#eee")
                line(p1, p2, :stroke)
                circle(mid, 6, :fill)
                sethue("#f00")
                circle(c, 6, :stroke)=#
                if sqrt(c.x^2+c.y^2) < r
                    sethue("#f00")
                end
                circle(c, 2, :fill)
                circle(mid, 4, :fill)
                line(c, mid, :stroke)
                sethue("#000")
                arc2r(c, p2, p1, :stroke)
            end
            if has_int
                break
            end
        end
        if has_int
            break
        end
    end

    for s in species(N)
        sethue("#eee")
        if typeof(N) <: AbstractBipartiteNetwork
            if s in species(N, 1)
                sethue("#0f0")
            else
                sethue("#0ff")
            end
        end

        circle(points[s], 8, :fill)
        sethue("#000")
        circle(points[s], 8, :stroke)
    end

    finish()
end
