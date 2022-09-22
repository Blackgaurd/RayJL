struct Triangle <: Object
    v1::Vec3
    v2::Vec3
    v3::Vec3
    material::Material
    N::Vec3 # normal

    Triangle(v1::Vec3, v2::Vec3, v3::Vec3, material::Material) = new(v1, v2, v3, material, normalize(cross(v2 - v1, v3 - v1)))
end

function find_normal(t::Triangle, ray_d::Vec3, intersect::Vec3)::Vec3
    if tt_angle(ray_d, t.N) > tt_angle(ray_d, -t.N)
        return t.N
    end
    -t.N
end

function find_intersect(t::Triangle, ray_o::Vec3, ray_d::Vec3)::Tuple{Bool, Float32}
    EPSILON = 1e-6

    edge1 = t.v2 - t.v1
    edge2 = t.v3 - t.v1
    h = cross(ray_d, edge2)
    a = dot(edge1, h)
    if abs(a) < EPSILON
        return (false, 0.0)
    end

    f = 1.0 / a
    s = ray_o - t.v1
    u = f * dot(s, h)
    if u < 0.0 || u > 1.0
        return (false, 0.0)
    end

    q = cross(s, edge1)
    v = f * dot(ray_d, q)
    if v < 0.0 || u + v > 1.0
        return (false, 0.0)
    end

    t = f * dot(edge2, q)
    if t < EPSILON
        return (false, 0.0)
    end
    (true, t)
end