struct Reflect <: Material
    Reflect() = new()
end

function reflect(ray_d::Vec3, normal::Vec3)::Vec3
    (ray_d - normal * 2 * dot(ray_d, normal)) |> normalize
end