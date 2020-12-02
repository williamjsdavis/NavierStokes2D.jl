module NavierStokes2D

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

end
