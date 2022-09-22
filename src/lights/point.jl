struct PointLight <: Light
    position::Vec3
    color::Vec3
    intensity::Float64
end

function direction_at(light::PointLight, point::Vec3)::Vec3
    (light.position - point) |> normalize
end