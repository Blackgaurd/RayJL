struct Ray3D
    # Px = ox + t*dx
    # Py = oy + t*dy
    # Pz = oz + t*dz

    o::Vec3 # origin
    d::Vec3 # direction
    color::Color
    intensity::Float64

    Ray3D(origin::Vec3, direction::Vec3, color::Color, intensity::Real) = new(origin, normalize(direction), color, intensity)
end

function ray_from_points(p1::Vec3, p2::Vec3, color::Color, intensity::Real)::Ray3D
    return Ray3D(p1, normalize(p2 - p1), color, intensity)
end

function point(r::Ray3D, t::Float64)::Vec3
    return r.o + r.d * t
end

function find_reflection(d::Ray3D, normal::Vec3)::Vec3
    return normalize(d.d - 2 * dot(d.d, normal) * normal)
end

function normalize(ray::Ray3D)::Ray3D
    return Ray3D(ray.o, normalize(ray.d), ray.color, ray.intensity)
end