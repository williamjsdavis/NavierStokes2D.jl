abstract type FluidSolution end

mutable struct DiffusionSolution{T<:Union{Array{Float64,2},Nothing}} <: FluidSolution
    u::Array{Float64,2}

    u_analytic::T
    errors::T

    prob::DiffusionProblem
    retcode::Bool
end
function DiffusionSolution(prob::DiffusionProblem, retcode::Bool)
    u_analytic, errors = get_analytic(prob.model, prob.cache.u, prob.cache.t)
    return DiffusionSolution(prob.cache.u, u_analytic, errors, prob, retcode)
end
function get_analytic(model::DiffusionModel{T}, u, t) where T<:Function
    u_analytic = model.u_analytic(t)
    errors = abs.(u - u_analytic)
    return u_analytic, errors
end
get_analytic(model::DiffusionModel{Nothing}, u, t) = nothing, nothing
