abstract type Reflect <: Material end

function reflect(ray_d::Vec3, normal::Vec3)::Vec3
    (ray_d - normal * 2 * ray_d ⋅ normal) |> normalize
end