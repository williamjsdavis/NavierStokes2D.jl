# NOTE: Add staggered grids
struct Grid
    xmax::Float64
    ymax::Float64

    nx::Int64
    ny::Int64

    Δx::Float64
    Δy::Float64

    xRange::Array{Float64,1}
    yRange::Array{Float64,1}

    function Grid(xmax, ymax, nx, ny)
        Δx = 2*xmax/(nx-1)
        Δy = 2*ymax/(ny-1)

        xRange = (-xmax:Δx:xmax)
        yRange = (-ymax:Δy:ymax)

        return new(xmax, ymax, nx, ny, Δx, Δy, xRange, yRange)
    end
end
