struct Plane <: Object
    # infinite plane
    # ax + by + cz + d = 0
    a::Float64
    b::Float64
    c::Float64
    d::Float64

    texture::Texture

    Plane(a::Float64, b::Float64, c::Float64, d::Float64, texture::Texture) = new(a, b, c, d, texture)
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
    # with ray: (x, y, z) + t * (dx, dy, dz)
    # a(t * dx) + b(t * dy) + c(t * dz) + d = 0
    # at * adx + bt * bdy + ct * cdz + d = 0
    # t(a + b + c) + adx + bdy + cdz + d = 0
    # t = -(a + b + c) / (adx + bdy + cdz + d)

    t = -(w.a + w.b + w.c) / (r.d.x + r.d.y + r.d.z + w.d)
    if t < 0
        return false, 0
    end
    return true, t
end

function find_normal(w::Plane, p::Vec3)::Vec3
    return normalize(Vec3(w.a, w.b, w.c))
end
