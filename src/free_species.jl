#=

Probability that each species has no interaction

=#
function species_is_free(A::Array{Float64,2})
   return vec(prod(1.0 .- nodiag(A),2)) .* vec(prod(1.0 .- nodiag(A),1))
end

function free_species(A::Array{Float64,2})
   return A |> species_is_free |> sum
end
