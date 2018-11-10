
# safe log(x) function, log 0 = 0
safelog(x) = x > zero(x) ? log2(x) : zero(x)
safediv(x, y) = y == zero(y) ? zero(y) : x / y
# general functions for entropy


function entropy(P::AbstractArray)
    return - sum(P .* safelog.(P))
end

function entropy(P::AbstractArray, dims::I) where I <: Int
    return entropy(sum(P', dims=dims))
end

function conditionalentropy(P::AbstractArray, dims::I) where I <: Int
    #marginals = dims==1 ? sum(P, dims=2) : sum(P, dims=1)
    return - sum(P .* safelog.(safediv.(P, sum(P', dims=dims))))
end

function mutualinformation(P::AbstractArray)
    return entropy(P, 1) - conditionalentropy(P, 1)
end

function varianceinformation(P::AbstractArray)
    return conditionalentropy(P, 1) + conditionalentropy(P, 2)
end

function diffentropyuniform(P::AbstractArray)
    return log2(length(P)) - entropy(P, 1) - entropy(P, 2)
end

function diffentropyuniform(P::AbstractArray, dims::Int)
    return log2(size(P)[dims]) - entropy(P, dims)
end
