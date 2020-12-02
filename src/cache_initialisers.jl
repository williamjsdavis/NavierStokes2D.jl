init_cache(model, method::ExplicitDiffusion) =
    ExplicitDiffusionCache(copy(model.u0), copy(model.u0), copy(model.parameters.tspan[1]))
function init_cache(model, method::CrankNickolsonDiffusion)
    u     = copy(model.u0)
    uprev = copy(model.u0)
    rhs   = copy(model.u0)

    a1, a2 = init_CN(model)

    t = copy(mod_test.parameters.tspan[1])

    return CNDiffusionCache(u, uprev, rhs, a1, a2, t);
end
function init_cache(model, method::ADIDiffusion)
    u     = copy(model.u0)
    uhalf = copy(model.u0)
    uprev = copy(model.u0)
    rhs   = copy(model.u0)

    a1x, a1y, a2x, a2y = init_ADI(model)

    t = copy(mod_test.parameters.tspan[1])

    return ADIDiffusionCache(u, uhalf, uprev, rhs, a1x, a1y, a2x, a2y, t);
end
