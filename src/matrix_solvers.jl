function init_CN(model)
    nx, ny = model.grid.nx, model.grid.ny
    Δx, Δy = model.grid.Δx, model.grid.Δy
    ν, Δt  = model.parameters.ν, model.Δt

    Nx = (nx-2)
    Ny = (ny-2)
    Nxy = Nx*Ny
    βx = 0.5*ν*Δt/(Δx*Δx)
    βy = 0.5*ν*Δt/(Δy*Δy)

    # New a1
    a1 = spzeros(Nxy,Nxy)
    ij_ind = LinearIndices((1:Ny, 1:Nx))
    for ij in ij_ind
        a1[ij,ij] = 1 + 2*βx + 2*βy
    end
    for ij in 1:Nx*(Ny-1)
        a1[view(ij_ind,2:Ny,:)[ij],view(ij_ind,1:Ny-1,:)[ij]] = -βy # Up
        a1[view(ij_ind,1:Ny-1,:)[ij],view(ij_ind,2:Ny,:)[ij]] = -βy # Down
    end
    for ij in 1:(Nx-1)*Ny
        a1[view(ij_ind,:,2:Nx)[ij],view(ij_ind,:,1:Nx-1)[ij]] = -βx # Right
        a1[view(ij_ind,:,1:Nx-1)[ij],view(ij_ind,:,2:Nx)[ij]] = -βx # Left
    end

    # New a2
    a2 = spzeros(Nxy,Nxy)
    ij_ind = LinearIndices((1:Ny, 1:Nx))
    for ij in ij_ind
        a2[ij,ij] = 1 - 2*βx - 2*βy
    end
    for ij in 1:Nx*(Ny-1)
        a2[view(ij_ind,2:Ny,:)[ij],view(ij_ind,1:Ny-1,:)[ij]] = βy # Up
        a2[view(ij_ind,1:Ny-1,:)[ij],view(ij_ind,2:Ny,:)[ij]] = βy # Down
    end
    for ij in 1:(Nx-1)*Ny
        a2[view(ij_ind,:,2:Nx)[ij],view(ij_ind,:,1:Nx-1)[ij]] = βx # Right
        a2[view(ij_ind,:,1:Nx-1)[ij],view(ij_ind,:,2:Nx)[ij]] = βx # Left
    end

    a1_lu = factorize(a1)
    return a1_lu, a2
end
function init_ADI(model)
    nx, ny = model.grid.nx, model.grid.ny
    Δx, Δy = model.grid.Δx, model.grid.Δy
    ν, Δt  = model.parameters.ν, model.Δt

    βx = 0.5*ν*Δt/(Δx*Δx)
    βy = 0.5*ν*Δt/(Δy*Δy)
    d1x = ones(nx-2) .+ 2 * βx
    e1x = -βx * ones(nx-3)
    d1y = ones(ny-2) .+ 2 * βy
    e1y = -βy * ones(ny-3)
    # matrix ( I - 0.5 nu dt delta_x^2 )
    a1x = SymTridiagonal(d1x,e1x)
    a1y = SymTridiagonal(d1y,e1y)

    d2x = ones(nx-2) .- 2 * βx
    e2x = -βx * ones(nx-3)
    d2y = ones(ny-2) .- 2 * βy
    e2y = -βy * ones(ny-3)
    # matrix ( I + 0.5 nu dt delta_x^2)
    a2x = SymTridiagonal(d2x,-e2x)
    a2y = SymTridiagonal(d2y,-e2y)

    #LDLt factorize
    a1x_ldlt = factorize(a1x)
    a1y_ldlt = factorize(a1y)
    return a1x_ldlt, a1y_ldlt, a2x, a2y
end
