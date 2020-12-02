abstract type FluidModel end

# NOTE: Should add a test for matching u0 with grid
mutable struct DiffusionModel{T<:Union{Function,Nothing}} <: FluidModel
    u0::Array{Float64,2}
    u_analytic::T

    grid::Grid
    parameters::Parameters

    Δt::Float64
    t::Array{Float64,1}

    function DiffusionModel(u0, u_analytic::T, grid, parameters) where T<:Union{Function,Nothing}
        Δt = parameters.σ*grid.Δx*grid.Δy/parameters.ν
        t = parameters.tspan[1]:Δt:parameters.tspan[2]
        return new{T}(u0, u_analytic, grid, parameters, Δt ,t)
    end
end
DiffusionModel(grid, parameters) = DiffusionModel(zeros(grid.ny, grid.nx), nothing, grid, parameters)
DiffusionModel(u0, grid, parameters) = DiffusionModel(u0, nothing, grid, parameters);
