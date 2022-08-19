struct Sphere <: Object
    o::Vec3 # origin
    r::Float64 # radius
    texture::Texture

    Sphere(origin::Vec3, radius::Real, texture::Texture) = radius <= 0 ?
        error("radius of sphere must be positive") :
        new(origin, radius, texture)
end

function find_intersection(s::Sphere, r::Ray3D)::Tuple{Bool,Float64}
    a = r.d.x^2 + r.d.y^2 + r.d.z^2
    b = 2 * r.d.x * (r.o.x - s.o.x) + 2 * r.d.y * (r.o.y - s.o.y) + 2 * r.d.z * (r.o.z - s.o.z)
    c = s.o.x^2 + s.o.y^2 + s.o.z^2
    c += r.o.x^2 + r.o.y^2 + r.o.z^2
    c -= 2 * (s.o.x * r.o.x + s.o.y * r.o.y + s.o.z * r.o.z)
    c -= s.r^2

    D = b^2 - 4 * a * c
    if D < 0
        return false, 0
    end

    t = (-b - sqrt(D)) / (2 * a)
    return true, t
end

function find_normal(s::Sphere, p::Vec3)::Vec3
    ret = p - s.o
    return normalize(ret)
end

