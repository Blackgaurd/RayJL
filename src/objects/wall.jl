struct Wall
    # infinite plane defined by a point and a normal

    n::Vec3 # normal
    p::Vec3 # point on plane
    ref::Float64 # reflectance ∈ [0, 1]
    b::Float64 # brightness ∈ [0, 1]
end

function find_intersection(w::Wall, r::Ray3D)::Tuple{Bool,Float64}
    # ray origin: (o1, o2, o3)
    # ray direction: (d1, d2, d3)
    # ray equation: (x, y, z) = (o1 + d1*t, o2 + d2*t, o3 + d3*t)

    # point of wall: (p1, p2, p3)
    # normal of wall: (N1, N2, N3)
    # plane equation: N1(x - p1) + N2(y - p2) + N3(z - p3) = 0

    # solve for t: N1(o1 + d1*t - p1) + N2(o2 + d2*t - p2) + N3(o3 + d3*t - p3) = 0
    # t = (N1(p1 - o1) + N2(p2 - o2) + N3(p3 - o3)) / (N1*d1 + N2*d2 + N3*d3)

    (o1, o2, o3) = (r.o.x, r.o.y, r.o.z)
    (d1, d2, d3) = (r.d.x, r.d.y, r.d.z)
    (p1, p2, p3) = (w.p.x, w.p.y, w.p.z)
    (N1, N2, N3) = (w.n.x, w.n.y, w.n.z)

    t = N1 * (p1 - o1) + N2 * (p2 - o2) + N3 * (p3 - o3)
    t /= N1 * d1 + N2 * d2 + N3 * d3

    if t < 0
        return false, 0
    end
    return true, t
end

function find_normal(w::Wall, p::Vec3)::Vec3
    return w.n
end
