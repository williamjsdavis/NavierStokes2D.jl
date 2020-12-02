""" Problem = model + method + (cache) """
abstract type FluidProblem end

mutable struct DiffusionProblem{MethodType<:DiffusionMethod, CacheType<:DiffusionCache} <: FluidProblem
    model::DiffusionModel
    method::MethodType
    cache::CacheType
end
function DiffusionProblem(model, M::MethodType) where MethodType
    cache = init_cache(model, M)
    CacheType = typeof(cache)
    return DiffusionProblem{MethodType, CacheType}(model, M, cache)
end
