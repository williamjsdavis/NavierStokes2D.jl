using NavierStokes2D
using Test

grid = Grid(1., 2., 16, 32)
params = Parameters(0.1, 0.2, (0.0, 1.0))
include("analytic_functions.jl")
u₀ = make_gaussian(grid)
u_analytic(t) = solution_gaussian(grid, t, params.ν)
model = DiffusionModel(zeros(16, 32), grid, params)
model_plus_ana = DiffusionModel(u₀, u_analytic, grid, params)

@testset "Grid tests" begin

    grid = Grid(1., 2., 16, 32)
    @test grid.xmax == 1.0
    @test grid.ymax == 2.0
    @test grid.nx == 16
    @test grid.ny == 32
    @test size(grid.xRange) == (16,)
    @test size(grid.yRange) == (32,)
    @test isa(grid.Δx, Float64)
    @test isa(grid.Δy, Float64)

end

@testset "Parameters tests" begin

    params = Parameters(0.1, 0.2, (0.0, 1.0))
    @test params.ν == 0.1
    @test params.σ == 0.2
    @test length(params.tspan) == 2

end

@testset "DiffusionModel tests" begin

    grid = Grid(1., 2., 16, 32)
    params = Parameters(0.1, 0.2, (0.0, 1.0))
    model = DiffusionModel(zeros(16, 32), grid, params)
    @test model.u_analytic == nothing
    @test isa(model.Δt, Float64)
    @test isa(model.t, Vector{Float64})

    include("analytic_functions.jl")
    u₀ = make_gaussian(grid)
    u_analytic(t) = solution_gaussian(grid, t, params.ν)
    model_plus_ana = DiffusionModel(u₀, u_analytic, grid, params)
    @test isa(model_plus_ana.u_analytic, Function)
    @test isa(model_plus_ana.Δt, Float64)
    @test isa(model_plus_ana.t, Vector{Float64})

end

@testset "Cache tests" begin

    u = zeros(16, 32)
    explicitDiffusionCache = ExplicitDiffusionCache(u, copy(u), 0.0)
    @test explicitDiffusionCache.u == u
    @test explicitDiffusionCache.uprev == u
    @test explicitDiffusionCache.t == 0.0

    # NOTE: Assume other caches test similarly

end
