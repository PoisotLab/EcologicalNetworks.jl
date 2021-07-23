
"""
abstract type NetworkGenerator end
"""
abstract type NetworkGenerator end 
Base.size(gen::NetworkGenerator) = gen.size

"""
    Base.rand(gen::NetworkGenerator) 
"""
function Base.rand(gen::NetworkGenerator) 
    size(gen)[1] == size(gen)[2] ? rand(gen, UnipartiteNetwork) : rand(gen, BipartiteNetwork)
end
function Base.rand(generator::NetworkGenerator, ::Type{T}) where {T <: AbstractEcologicalNetwork}    
    return _generate!(generator, T(zeros(Bool, size(generator)))) 
end

function Base.rand(generator::NetworkGenerator, target::T) where {T <: UnipartiteNetwork} 
    size(generator)[1] == size(generator)[2] || @error "can't generate a unipartite networks with unequal dimensions"
    return _generate!(generator, target) 
end

function Base.rand(generator::NetworkGenerator, target::T) where {T <: BipartiteNetwork} 
    return _generate!(generator, target) 
end