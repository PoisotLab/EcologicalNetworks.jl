# Test with figures

include("src/EcologicalNetwork.jl")
using EcologicalNetwork

# Force atlas

N = thompson_townsend_catlins()

steps = 20
k = sqrt(1.0/richness(N))
θ = 0.1
dθ = θ/(steps+1)

nohub, linlog = true, false

positions = Dict(s => rand(2) for s in species(N))

for step in 1:steps
    # Displacement within the step
    displacement = Dict(s => [0.0, 0.0] for s in species(N))
    for s in species(N,1)
        println(typeof(s))
        Δ = (positions[s] .- hcat(collect(values(positions))...))'
        distance = sqrt(Δ.^2)
        println(size(distance))
        distance[distance .<= 0.01] = 0.01
        println(size(distance))
        ii = first(find(i -> species(N)[i]==s, 1:richness(N)))
        thisrow = N[ii,:]
        displacement_force = k * k ./ distance.^2
        if nohub
            displacement_force = displacement_force / (sum(thisrow)+1.0)
        end
        if linlog
            displacement_force = log.(displacement_force .+ 1.0)
        end
        println(displacement_force[1:3,:])
        println(size(thisrow .*distance/k))
        println(size(displacement_force))
        movement = Δ .* (displacement_force .- thisrow .*distance/k)
        displacement[s] += vec(sum(movement, 1))
    end
    total_length = sum(hcat(collect(values(displacement))...).^2,1)
    total_length[total_length.<=0.01] = 0.01
    total_length = Dict(zip(species(N), total_length))
    for (key,v) in displacement
        positions[key] = displacement[key].*θ./total_length[key]
    end
    θ -= dθ
end
