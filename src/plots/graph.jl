
function graph_layout(N; steps=15000, L=50.0, R=0.05)
    nodes = Dict([species(N)[i] => Dict(:x => rand()-0.5, :y => rand()-0.5, :fx => 0.0, :fy => 0.0, :n => eltype(species(N))[]) for i in 1:richness(N)])
    for s in species(N)
        neighbors = eltype(species(N))[]
        if s in species(N,2)
            for s2 in species(N,1)
                if has_interaction(N, s2, s)
                    push!(neighbors, s2)
                end
            end
        end
        if s in species(N,1)
            for s2 in species(N,2)
                if has_interaction(N, s, s2)
                    push!(neighbors, s2)
                end
            end
        end
        neighbors = filter(x -> x!=s, neighbors)
        nodes[s][:n] = neighbors
    end
    return graph_layout(N, nodes, steps=steps, L=L, R=R)
end

function graph_layout(N, nodes; steps=15000, L=50.0, R=0.05)

    Δt = 0.01
    Kr = 6250.0
    Ks = Kr/(R*L^3)
    max_squared_displacement = Δt*5.5

    for step in 1:steps
        # Repulsion between all pairs
        for s1_i in eachindex(species(N)[1:(end-1)])
            for s2_i in (s1_i+1):richness(N)
                s1, s2 = species(N)[[s1_i,s2_i]]
                dx = nodes[s1][:x] - nodes[s2][:x]
                dy = nodes[s1][:y] - nodes[s2][:y]
                if ((dx != 0.0) | (dy != 0.0))
                    squared_distance = dx*dx + dy*dy
                    distance = sqrt(squared_distance)
                    force = Kr/squared_distance
                    fx = force * dx / distance
                    fy = force * dy / distance
                    nodes[s1][:fx] += fx
                    nodes[s1][:fy] += fy
                    nodes[s2][:fx] -= fx
                    nodes[s2][:fy] -= fy
                end
            end
        end
        # Attraction between connected pairs
        for s1 in species(N)
            if length(nodes[s1][:n]) > 0
                for s2 in nodes[s1][:n]
                    spos = first(find(species(N).==s1))
                    s2pos = first(find(species(N).==s2))
                    if spos < s2pos
                        dx = nodes[s1][:x] - nodes[s2][:x]
                        dy = nodes[s1][:y] - nodes[s2][:y]
                        if ((dx != 0.0) | (dy != 0.0))
                            distance = sqrt(dx*dx + dy*dy)
                            force = Ks * (distance - L)
                            fx = force * dx / distance
                            fy = force * dy / distance
                            nodes[s1][:fx] -= fx
                            nodes[s1][:fy] -= fy
                            nodes[s2][:fx] += fx
                            nodes[s2][:fy] += fy
                        end
                    end
                end
            end
        end
        # Attraction to the center
        for s1 in species(N)
            dx = nodes[s1][:x] - 0.0
            dy = nodes[s1][:y] - 0.0
            if ((dx != 0.0) | (dy != 0.0))
                distance = sqrt(dx*dx + dy*dy)
                force = Ks * (distance - L) * 0.1
                fx = force * dx / distance
                fy = force * dy / distance
                nodes[s1][:fx] -= fx
                nodes[s1][:fy] -= fy
            end
        end
        # Movement
        for s in species(N)
            dx = Δt * nodes[s][:fx]
            dy = Δt * nodes[s][:fy]
            squared_displacement = dx*dx + dy*dy
            if squared_displacement > max_squared_displacement
                sc = sqrt(max_squared_displacement / squared_displacement)
                dx *= sc
                dy *= sc
            end
            nodes[s][:x] += dx
            nodes[s][:y] += dy
            nodes[s][:fx] = 0.0
            nodes[s][:fy] = 0.0
        end
    end
    return (N, nodes)
end

function graph_network_plot{T<:AbstractEcologicalNetwork}(N::T, nodes; filename="network.png", steps=15000, L=50.0, R=0.05, fontname="Noto Sans Condensed", fontsize=16, names=true)

    r = 550.0
    mx = minimum([n[:x] for (k,n) in nodes])
    my = minimum([n[:y] for (k,n) in nodes])
    Mx = maximum([n[:x] for (k,n) in nodes])
    My = maximum([n[:y] for (k,n) in nodes])

    points = Dict([
        s => Point(((nodes[s][:x] - mx)/(Mx-mx) * 2.0 - 1.0) * r, ((nodes[s][:y] - my)/(My-my) * 2.0 - 1.0) * r) for s in species(N)
    ])


    Drawing(1360, 1360, filename)
    setfont(fontname, fontsize)
    origin()

    if typeof(N) <: QuantitativeNetwork
      sethue("#777")
      setopacity(1.0)
   end
   if typeof(N) <: BinaryNetwork
      sethue("#333")
      setline(3.5)
      setopacity(0.5)
   end
   if typeof(N) <: ProbabilisticNetwork
      sethue("#333")
      setline(3.5)
   end

    for s1 in species(N,1)
        p1 = points[s1]
        for s2 in species(N,2)
            p2 = points[s2]
            if has_interaction(N, s1, s2)
                lw = 3.5
                if typeof(N) <: QuantitativeNetwork
                   int_s = N[s1,s2]./maximum(N.A)
                   lw = int_s*8.0+2.0
                   setline(lw)
                end
                if typeof(N) <: ProbabilisticNetwork
                   setopacity(N[s1,s2])
                end
                if s1 != s2
                    if typeof(N) <: AbstractUnipartiteNetwork
                        arrow(p1, p2, linewidth=lw, arrowheadlength=25)
                    else
                        line(p1, p2, :stroke)
                    end
                else
                    arrow(Point(p1.x+40, p1.y), 40, π*1.1, π/1.1, linewidth=lw, arrowheadlength=25)
                end
            end
        end
    end
    setopacity(1.0)

    setline(2)

    for s in species(N)

        sethue("#fff")
        circle(points[s], 12, :fill)

        if typeof(N) <: AbstractBipartiteNetwork
            if s in species(N, 1)
                sethue(230/255, 159/255, 0/255)
            else
                sethue(0/255, 114/255, 178/255)
            end
        else
            sethue(0/255, 158/255, 115/255)
        end

        circle(points[s], 12, :stroke)

        if names
            sethue("#000")
            settext(string(s), points[s], halign="center", valign="center")
        end
    end

    finish()
end

function graph_network_plot{T<:AbstractEcologicalNetwork}(N::T; filename="network.png", steps=15000, L=50.0, R=0.05, fontname="Noto Sans Condensed", fontsize=16, names=true)
    l = graph_layout(N, steps=steps, L=L, R=R)
    graph_network_plot(l..., filename=filename, fontname=fontname, fontsize=fontsize, names=names)
end
