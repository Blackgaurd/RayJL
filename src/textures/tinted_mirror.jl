struct TintedMirror <: Texture
    reflectance::Float64 # ∈ [0, 1], 0 = no reflection, 1 = perfect reflection
    tint::Color
    reflect::Bool

    TintedMirror(reflectance::Real, tint::Color) = reflectance < 0 || reflectance > 1 ?
        error("reflectance must be between 0 and 1") :
        new(reflectance, tint, true)
end

function apply_reflectance(texture::TintedMirror, ray::Ray3D)::Ray3D
    return Ray3D(
        ray.o,
        ray.d,
        mix(texture.tint, ray.color),
        texture.reflectance * ray.intensity
    )
end