struct Mirror <: Texture
    reflectance::Float64 # ∈ [0, 1], 0 = no reflection, 1 = perfect reflection
    reflect::Bool

    Mirror(reflectance::Real) = reflectance < 0 || reflectance > 1 ?
        error("reflectance must be between 0 and 1") :
        new(reflectance, true)
end

function apply_reflectance(texture::Mirror, ray::Ray3D)::Ray3D
    return Ray3D(
        ray.o,
        ray.d,
        ray.color,
        texture.reflectance * ray.intensity
    )
end