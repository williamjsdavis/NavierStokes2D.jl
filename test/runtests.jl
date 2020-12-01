using NavierStokes2D
using Test

Grid(5., 5., 64, 64)

@testset "NavierStokes2D.jl" begin

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
