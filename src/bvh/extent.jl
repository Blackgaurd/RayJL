bvh_plane_normals = [
    Vec3(0, 0, 1),
    Vec3(0, 1, 0),
    Vec3(1, 0, 0),
    Vec3(sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3),
    Vec3(-sqrt(3) / 3, sqrt(3) / 3, sqrt(3) / 3),
    Vec3(-sqrt(3) / 3, -sqrt(3) / 3, sqrt(3) / 3),
    Vec3(sqrt(3) / 3, -sqrt(3) / 3, sqrt(3) / 3),
]

mutable struct _Range
    min::Float32
    max::Float32
end

function in(x::Real, r::_Range)::Bool
    r.min <= x < r.max
end

struct Extents
    # bounding box of a set of triangles
    # basically the upper and lower bounds of a triangle
    # in each of the directions from the bvh_plane_normals
    d::Array{_Range,1}

    Extents() = begin
        new([_Range(Inf32, -Inf32) for i in 1:size(bvh_plane_normals)[1]])
    end

    Extents(p1::Vec3, p2::Vec3, p3::Vec3, p...) = begin
        d = [_Range(Inf32, -Inf32) for i in 1:size(bvh_plane_normals)[1]]
        for point in [p1, p2, p3, p...]
            for i in 1:size(bvh_plane_normals)[1]
                p_dot_normal = dot(point, bvh_plane_normals[i])
                d[i].min = min(d[i].min, p_dot_normal)
                d[i].max = max(d[i].max, p_dot_normal)
            end
        end
        new(d)
    end

    Extents(extent1::Extents, extent2::Extents, extent_n...) = begin
        d = [_Range(Inf32, -Inf32) for i in 1:size(bvh_plane_normals)[1]]
        for extent in [extent1, extent2, extent_n...]
            for i in 1:size(bvh_plane_normals)[1]
                d[i].min = min(d[i].min, extent.d[i].min)
                d[i].max = max(d[i].max, extent.d[i].max)
            end
        end
        new(d)
    end
end

function intersects_extent(extents::Extents, ray_o::Vec3, ray_d::Vec3)::Bool
    max_t_near = -Inf32
    min_t_far = Inf32

    for i in 1:size(bvh_plane_normals)[1]
        N = bvh_plane_normals[i]
        N_o = dot(N, ray_o)
        N_d = dot(N, ray_d)
        t_near = (extents.d[i].min - N_o) / N_d
        t_far = (extents.d[i].max - N_o) / N_d

        if t_near > t_far
            t_near, t_far = t_far, t_near
        end

        max_t_near = max(max_t_near, t_near)
        min_t_far = min(min_t_far, t_far)
    end

    max_t_near < min_t_far
end

function centroid(extent::Extents)::Vec3
    c = Vec3(0, 0, 0)
    for i in 1:size(bvh_plane_normals)[1]
        c += bvh_plane_normals[i] * (extent.d[i].min + extent.d[i].max) / 2.0
    end
    c
end
