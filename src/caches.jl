abstract type DiffusionCache end

mutable struct ExplicitDiffusionCache <: DiffusionCache
    u::Array{Float64,2}
    uprev::Array{Float64,2}
    t::Float64
end
# NOTE: Add types for a matrices
mutable struct CNDiffusionCache <: DiffusionCache
    u::Array{Float64,2}
    uprev::Array{Float64,2}
    rhs::Array{Float64,2}
    a1
    a2
    t::Float64
end
mutable struct ADIDiffusionCache <: DiffusionCache
    u::Array{Float64,2}
    uhalf::Array{Float64,2}
    uprev::Array{Float64,2}
    rhs::Array{Float64,2}
    a1x
    a1y
    a2x
    a2y
    t::Float64
end
