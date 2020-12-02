module NavierStokes2D

using SparseArrays, LinearAlgebra

include("grids.jl")
include("parameters.jl")
export Grid, Parameters

include("models.jl")
export DiffusionModel

include("caches.jl")
export ExplicitDiffusionCache, CNDiffusionCache, ADIDiffusionCache

include("methods_diffusion.jl")
export ExplicitDiffusion, CrankNickolsonDiffusion, ADIDiffusion
export perform_step!

include("cache_initialisers.jl")
export init_cache

include("matrix_solvers.jl")
export init_CN, init_ADI

include("boundary_conditions.jl")
export apply_BCs!

include("problems.jl")
export DiffusionProblem

include("solutions.jl")
export DiffusionSolution
export get_analytic

end
