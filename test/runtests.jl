using NavierStokes2D
using Test

Grid(5., 5., 64, 64)

@testset "NavierStokes2D.jl" begin

    test_grid = Grid(1., 2., 32, 64)
    @test test_grid.xmax == 1.0
    @test test_grid.ymax == 2.0
    @test test_grid.nx == 32
    @test test_grid.ny == 64
    @test size(test_grid.xRange) == (32,)
    @test size(test_grid.yRange) == (64,)

end
