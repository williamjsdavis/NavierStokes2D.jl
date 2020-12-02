abstract type DiffusionMethod end
struct ExplicitDiffusion <: DiffusionMethod end
struct CrankNickolsonDiffusion <: DiffusionMethod end
struct ADIDiffusion <: DiffusionMethod end

function perform_step!(model::DiffusionModel, method::ExplicitDiffusion, cache::ExplicitDiffusionCache)
    u  = cache.u
    un = cache.uprev
    nx = model.grid.nx
    ny = model.grid.ny
    Δx = model.grid.Δx
    Δy = model.grid.Δy
    Δt = model.Δt
    ν  = model.parameters.ν

    copy!(un,u)
    @inbounds for j in 2:ny-1, i in 2:nx-1
        u[j,i] = un[j,i] +
            ν*Δt/(Δx*Δx)*(un[j  ,i+1]-2*un[j,i]+un[j  ,i-1]) +
            ν*Δt/(Δy*Δy)*(un[j+1,i  ]-2*un[j,i]+un[j-1,i  ])
    end

    return nothing
end
function perform_step!(model::DiffusionModel, method::CrankNickolsonDiffusion, cache::CNDiffusionCache)
    u   = cache.u
    un  = cache.uprev
    rhs = cache.rhs
    a1  = cache.a1
    a2  = cache.a2

    copy!(un,u)

    unV = @view un[2:end-1,2:end-1]
    unVC = @view unV[:]
    uV = @view u[2:end-1,2:end-1]
    uVC = @view uV[:]
    rhsV = @view rhs[2:end-1,2:end-1]
    rhsVC = @view rhsV[:]

    mul!(rhsVC, a2, unVC)
    uVC .= a1\rhsV[:]

    return nothing
end
function perform_step!(model::DiffusionModel, method::ADIDiffusion, cache::ADIDiffusionCache)
    u      = cache.u
    uhalf  = cache.uhalf
    un     = cache.uprev
    rhs    = cache.rhs
    a1x    = cache.a1x
    a1y    = cache.a1y
    a2x    = cache.a2x
    a2y    = cache.a2y
    nx, ny = model.grid.nx, model.grid.ny

    copy!(un,u)

    un_i(i) = @view un[2:end-1,i]
    u_i(i) = @view u[2:end-1,i]
    rhs_j(j) = @view rhs[j,2:end-1]
    rhs_i(i) = @view rhs[2:end-1,i]
    uhalf_j(j) = @view uhalf[j,2:end-1]

    # Step one
    for i = 2:nx-1
        mul!(rhs_i(i), a2y, un_i(i))
    end
    for j = 2:ny-1
        ldiv!(uhalf_j(j), a1x, rhs_j(j))
    end

    # Step two
    for j = 2:ny-1
        mul!(rhs_j(j), a2x, uhalf_j(j))
    end
    for i = 2:nx-1
        ldiv!(u_i(i), a1y, rhs_i(i))
    end
    return nothing
end
