#=

Type I

=#
function null1(A::Array{Float64, 2})
   return ones(A) .* connectance(A)
end

#=

Type III out

=#
function null3out(A::Array{Float64, 2})
   p_rows = degree_out(A) ./ size(A)[2]
   return hcat(map((x) -> p_rows, [1:size(A)[2]])...)
end

#=

Type III in

=#
function null3in(A::Array{Float64, 2})
   return null3out(A')' # I don't work hard, so I work smart
end

#=

Type II

=#
function null2(A::Array{Float64, 2})
   return (null3in(A) .+ null3out(A))./2.0
end
