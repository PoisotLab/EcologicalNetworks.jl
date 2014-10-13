function nestedness_axis(A::Array{Float64,2}; axis::Int64=1)
   @assert axis in 1:2
   if axis == 2
      B = A
   else
      B = A'
   end
   S = size(B)[1]
   n = vec(sum(B, 2))
   num = 0.0
   den = 0.0
   for  j in 2:S
      for i in 1:(j-1)
         num += sum(B[i,:].*B[j,:])
         den += minimum([n[i], n[j]])
      end
   end
   return sum(num ./ den)
end

function nestedness(A::Array{Float64,2})
   n_1 = nestedness_axis(A, axis=1)
   n_2 = nestedness_axis(A, axis=2)
   n = (n_1 + n_2)/2.0
   return [n, n_1, n_2]
end
