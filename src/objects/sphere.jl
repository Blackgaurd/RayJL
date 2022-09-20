struct Sphere <: Object
    origin::Vec3
    radius::Float32
    material::Material
end

function find_normal(s::Sphere, ray_d::Vec3, intersect::Vec3)::Vec3
    (intersect - s.origin) |> normalize
end

function find_intersect(s::Sphere, ray_o::Vec3, ray_d::Vec3)::Tuple{Bool,Float32}
    a = ray_d.x^2 + ray_d.y^2 + ray_d.z^2
    b = 2 * (ray_d.x * (ray_o.x - s.origin.x) + ray_d.y * (ray_o.y - s.origin.y) + ray_d.z * (ray_o.z - s.origin.z))
    c = s.origin.x^2 + s.origin.y^2 + s.origin.z^2 + ray_o.x^2 + ray_o.y^2 + ray_o.z^2 - 2 * dot(s.origin, ray_o) - s.radius^2

    D = b^2 - 4 * a * c
    if D < 0
        return false, 0.0
    end

    t = (-b - sqrt(D)) / (2 * a)
    if t < 0
        return false, 0.0
    end
    return true, t
end