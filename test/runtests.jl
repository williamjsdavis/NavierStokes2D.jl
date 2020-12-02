using NavierStokes2D
using Test

grid = Grid(1., 2., 16, 32)
params = Parameters(0.1, 0.2, (0.0, 1.0))
include("analytic_functions.jl")
u₀ = make_gaussian(grid)
u_analytic(t) = solution_gaussian(grid, t, params.ν)
model = DiffusionModel(zeros(16, 32), grid, params)
model_plus_ana = DiffusionModel(u₀, u_analytic, grid, params)
prob2 = DiffusionProblem(model, CrankNickolsonDiffusion())

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

    grid = Grid(1., 2., 16, 32)
    params = Parameters(0.1, 0.2, (0.0, 1.0))
    model = DiffusionModel(zeros(16, 32), grid, params)
    cache = init_cache(model, ExplicitDiffusion())
    @test isa(cache, ExplicitDiffusionCache)

    # NOTE: Assume other caches test similarly

end

@testset "Diffusion methods tests" begin

    grid = Grid(1., 2., 16, 32)
    params = Parameters(0.1, 0.2, (0.0, 1.0))
    model = DiffusionModel(zeros(16, 32), grid, params)

    set_method = ExplicitDiffusion()
    cache = init_cache(model, ExplicitDiffusion())

    perform_step!(model, set_method, cache)

    @test isa(model, DiffusionModel)

    # TODO: Add more explicit tests here
    # NOTE: Assume other methods test similarly

end

@testset "Diffusion problems tests" begin

    grid = Grid(1., 2., 16, 32)
    params = Parameters(0.1, 0.2, (0.0, 1.0))
    model = DiffusionModel(zeros(16, 32), grid, params)

    set_method = ExplicitDiffusion()
    cache = init_cache(model, ExplicitDiffusion())

    prob = DiffusionProblem(model, set_method, cache)

    @test isa(prob, DiffusionProblem)
    # NOTE: Assume other methods test similarly

    prob1 = DiffusionProblem(model, ExplicitDiffusion())
    prob2 = DiffusionProblem(model, CrankNickolsonDiffusion())
    prob3 = DiffusionProblem(model, ADIDiffusion())

    @test typeof(prob1).parameters[1] == ExplicitDiffusion
    @test typeof(prob2).parameters[1] == CrankNickolsonDiffusion
    @test typeof(prob3).parameters[1] == ADIDiffusion
    @test typeof(prob1).parameters[2] == ExplicitDiffusionCache
    @test typeof(prob2).parameters[2] == CNDiffusionCache
    @test typeof(prob3).parameters[2] == ADIDiffusionCache

end

@testset "Diffusion solution tests" begin

    grid = Grid(1., 2., 16, 32)
    params = Parameters(0.1, 0.2, (0.0, 1.0))
    model = DiffusionModel(zeros(16, 32), grid, params)
    prob = DiffusionProblem(model, ExplicitDiffusion())
    sol = DiffusionSolution(prob, true)

    @test sol.u_analytic == nothing
    # NOTE: Assume other methods test similarly

    include("analytic_functions.jl")
    u₀ = make_gaussian(grid)
    u_analytic(t) = solution_gaussian(grid, t, params.ν)
    model_plus_ana = DiffusionModel(u₀, u_analytic, grid, params)
    prob_plus_ana = DiffusionProblem(model_plus_ana, ExplicitDiffusion())
    sol_plus_ana = DiffusionSolution(prob_plus_ana, true)

    @test isa(sol_plus_ana.u_analytic, Array{Float64, 2})
    @test isa(sol_plus_ana.errors, Array{Float64, 2})
    # NOTE: Assume other methods test similarly

end
