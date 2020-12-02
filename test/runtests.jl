using NavierStokes2D
using Test

Grid(5., 5., 64, 64)
Parameters(0.1, 0.2, (0.0, 1.0))

@testset "Grid tests" begin

    test_grid = Grid(1., 2., 16, 32)
    @test test_grid.xmax == 1.0
    @test test_grid.ymax == 2.0
    @test test_grid.nx == 16
    @test test_grid.ny == 32
    @test size(test_grid.xRange) == (16,)
    @test size(test_grid.yRange) == (32,)
    @test isa(test_grid.Δx, Float64)
    @test isa(test_grid.Δy, Float64)

end

@testset "Parameters tests" begin

    test_params = Parameters(0.1, 0.2, (0.0, 1.0))
    @test test_params.ν == 0.1
    @test test_params.σ == 0.2
    @test length(test_params.tspan) == 2

end
