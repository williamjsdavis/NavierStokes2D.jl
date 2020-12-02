function make_gaussian(grid::Grid)
    u0 = zeros(grid.ny, grid.nx)
    x = grid.xRange
    y = grid.yRange

    x₀ = 0.0
    y₀ = 0.0
    var₀ = 0.9
    T₀ = 1.0
    for j = 1 : grid.ny, i = 1 : grid.nx
        u0[j,i] = T₀*exp(-((x[i]-x₀)^2 + (y[j]-y₀)^2)/(2*var₀))
    end
    return u0
end
function solution_gaussian(grid::Grid, t, κ)
    uana = zeros(grid.ny, grid.nx)
    x = grid.xRange
    y = grid.yRange

    x₀ = 0.0
    y₀ = 0.0
    var₀ = 0.9
    T₀ = 1.0
    #t₀ = -0.1

    for j = 1 : grid.ny, i = 1 : grid.nx
        uana[j,i] = T₀/sqrt(1+4*κ*t/var₀)*
                exp(-((x[i]-x₀)^2 + (y[j]-y₀)^2)/(2*var₀+4*κ*t))
    end
    return uana
end
