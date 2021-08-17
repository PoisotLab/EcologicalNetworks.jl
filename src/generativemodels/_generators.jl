
"""
    NetworkGenerator
"""
abstract type NetworkGenerator end

"""
    Base.size(gen::NetworkGenerator) 
"""
Base.size(gen::NetworkGenerator) = gen.size

"""
    Base.rand(gen::NetworkGenerator) 
"""
function Base.rand(gen::NetworkGenerator)
    size(gen)[1] == size(gen)[2] ? rand(gen, UnipartiteNetwork) :
    rand(gen, BipartiteNetwork)
end

"""
    Base.rand(gen::NetworkGenerator, ::Type{T}) where {T<:AbstractEcologicalNetwork}
"""

function Base.rand(
    generator::NetworkGenerator,
    ::Type{T},
) where {T<:AbstractEcologicalNetwork}
    return _generate!(generator, T)
end
