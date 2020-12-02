module NavierStokes2D

include("grids.jl")
include("parameters.jl")
export Grid, Parameters

include("models.jl")
export DiffusionModel

include("caches.jl")
export ExplicitDiffusionCache, CNDiffusionCache, ADIDiffusionCache

end
