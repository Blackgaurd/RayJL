struct Plane <: Object
    # infinite plane
    # ax + by + cz + d = 0
    a::Float64
    b::Float64
    c::Float64
    d::Float64

    texture::Texture

    Plane(a::Real, b::Real, c::Real, d::Real, texture::Texture) = new(a, b, c, d, texture)
    Plane(p1::Vec3, p2::Vec3, p3::Vec3, texture::Texture) = begin
        # plane equation from three points
        v1 = p2 - p1
        v2 = p3 - p1
        normal = v1 * v2
        d = -dot(normal, p1)
        new(normal.x, normal.y, normal.z, d, texture)
    end
end

function find_intersection(w::Plane, r::Ray3D)::Tuple{Bool, Float64}
    # intersection of plane: ax + by + cz + d = 0
    # with ray: (x, y, z) = (ox + t * dx, oy + t * dy, oz + t * dz)
    # a(ox + t * dx) + b(oy + t * dy) + c(oz + t * dz) + d = 0
    # t = -(a * ox + b * oy + c * oz + d) / (a * dx + b * dy + c * dz)

    t = -(w.a * r.o.x + w.b * r.o.y + w.c * r.o.z + w.d)
    t /= (w.a * r.d.x + w.b * r.d.y + w.c * r.d.z)
    if t < 0
        return false, 0
    end
    return true, t
end

function find_normal(w::Plane, p::Vec3)::Vec3
    return normalize(Vec3(w.a, w.b, w.c))
end
