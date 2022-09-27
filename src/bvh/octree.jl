struct OctreeNode
    # based on the assumption that the bounding box is a cube

    x::_Range
    y::_Range
    z::_Range
    triangles::Array{Triangle,1}
    children::Array{OctreeNode,1}

    OctreeNode(x::Real, y::Real, z::Real, len::Real) = begin
        new(
            _Range(x, x + len),
            _Range(y, y + len),
            _Range(z, z + len),
            Triangle[],
            OctreeNode[],
        )
    end
end

function has_children(node::OctreeNode)::Bool
    !isempty(node.children)
end

function has_triangles(node::OctreeNode)::Bool
    !isempty(node.triangles)
end

function in_range(point::Vec3, node::OctreeNode)::Bool
    (point.x in node.x) && (point.y in node.y) && (point.z in node.z)
end

function insert_triangle!(node::OctreeNode, triangle::Triangle, centroid::Vec3, max_depth::Int)
    if max_depth == 0
        push!(node.triangles, triangle)
        return
    end

    if has_children(node)
        for child in node.children
            if in_range(centroid, child)
                insert_triangle!(child, triangle, centroid, max_depth - 1)
                return
            end
        end
    else
        if has_triangles(node)
            # max_depth ensures there will be only
            # 1 triangle at this point

            centroid2 = find_centroid(node.triangles[1])

            len = (node.x.max - node.x.min) / 2.0
            for i in 1:8
                push!(node.children, OctreeNode(
                    node.x.min + len * ((i - 1) % 2),
                    node.y.min + len * ((i - 1) % 4 >= 2),
                    node.z.min + len * (i > 4),
                    len,
                ))
                if in_range(centroid, node.children[i])
                    insert_triangle!(node.children[i], triangle, centroid, max_depth - 1)
                end
                if in_range(centroid2, node.children[i])
                    insert_triangle!(node.children[i], node.triangles[1], centroid2, max_depth - 1)
                end
            end
            empty!(node.triangles)
        else
            push!(node.triangles, triangle)
        end
    end
    nothing
end

function build_octree(triangles::Array{Triangle,1}, max_depth::Int)::OctreeNode
    # find the bounding box
    min_x = minimum(tri->min(tri.v1.x, tri.v2.x, tri.v3.x), triangles)
    max_x = maximum(tri->max(tri.v1.x, tri.v2.x, tri.v3.x), triangles)
    min_y = minimum(tri->min(tri.v1.y, tri.v2.y, tri.v3.y), triangles)
    max_y = maximum(tri->max(tri.v1.y, tri.v2.y, tri.v3.y), triangles)
    min_z = minimum(tri->min(tri.v1.z, tri.v2.z, tri.v3.z), triangles)
    max_z = maximum(tri->max(tri.v1.z, tri.v2.z, tri.v3.z), triangles)

    len = max(max_x - min_x, max_y - min_y, max_z - min_z)
    octree = OctreeNode(min_x, min_y, min_z, len)

    for triangle in triangles
        centroid = find_centroid(triangle)
        insert_triangle!(octree, triangle, centroid, max_depth)
    end

    octree
end
