module NavierStokes2D

include("grids.jl")
include("parameters.jl")

export Grid, Parameters

include("models.jl")

export DiffusionModel

end
