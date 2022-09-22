struct Refract <: Material
    ior::Float32
end

AIR_IOR = 1.0

function clamp(x::Float32, _min::Float32, _max::Float32)::Float32
    max(_min, min(_max, x))
end

function refract(ray_d::Vec3, normal::Vec3, ior::Float32)::Vec3
    n_dot_i = dot(normal, ray_d)
    air_ior = AIR_IOR

    if n_dot_i < 0
        n_dot_i = -n_dot_i
    else
        normal = -normal
        ior, air_ior = air_ior, ior
    end

    ior_ratio = air_ior / ior

    k = 1.0 - ior_ratio * ior_ratio * (1.0 - n_dot_i * n_dot_i)
    if k < 0
        return Vec3(0.0, 0.0, 0.0)
    end
    (ior_ratio * ray_d + (ior_ratio * n_dot_i - sqrt(k)) * normal) |> normalize
end

function fresnel(ray_d::Vec3, normal::Vec3, ior::Float32)::Float32
    cosi = clamp(dot(ray_d, normal), -1.0, 1.0)
    air_ior = AIR_IOR

    if cosi > 0
        air_ior, ior = ior, air_ior
    end

    ior_ratio = air_ior / ior

    sint = ior_ratio * sqrt(max(0.0, 1.0 - cosi^2))
    if sint >= 1.0
        return 1.0
    end

    cost = sqrt(max(0.0, 1.0 - sint^2))
    cosi = abs(cosi)
    Rs = ((air_ior * cosi) - (ior * cost)) / ((air_ior * cosi) + (ior * cost))
    Rp = ((ior * cosi) - (air_ior * cost)) / ((ior * cosi) + (air_ior * cost))
    (Rs^2 + Rp^2) / 2.0
end