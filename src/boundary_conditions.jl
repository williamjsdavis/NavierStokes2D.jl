# NOTE: Simple test BCs to start with
function apply_BCs!(cache)
    u = cache.u
    u[1,:]   .= 0.0
    u[end,:] .= 0.0
    u[:,1]   .= 0.0
    u[:,end] .= 0.0
    return nothing
end
