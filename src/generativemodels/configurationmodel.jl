"""
    ConfigurationModel

    cite here
"""
mutable struct ConfigurationModel{IT <: Integer} <: NetworkGenerator
    size::Tuple{IT,IT}
    degreesequence::Vector{IT}
end

