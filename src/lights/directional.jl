struct DirectionalLight <: Light
    direction::Vec3
    color::Vec3
    intensity::Float32

    DirectionalLight(direction::Vec3, color::Vec3, intensity::Real) = new(-direction, color, intensity)
end

function direction_at(l::DirectionalLight, point::Vec3)::Vec3
    l.direction
end