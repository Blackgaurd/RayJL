struct OctreeNode
    # based on the assumption that the bounding box is a cube

    x::_Range
    y::_Range
    z::_Range
    extent::Extents
    triangles::Array{Triangle,1}
    children::Array{OctreeNode,1}

    OctreeNode(x::Float32, y::Float32, z::Float32, len::Float32) = begin
        new(
            _Range(x, x + len),
            _Range(y, y + len),
            _Range(z, z + len),
            Extents(),
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
            if in_range(centroid, child.extent)
                insert_triangle!(child, triangle, centroid, max_depth - 1)
                return
            end
        end
    else
        if has_triangles(node)
            # max_depth ensures there will be only
            # 1 triangle at this point

            centroid2 = centroid(node.triangles[1])

            len = (node.x.max - node.x.min) / 2.0
            for i in 1:8
                push!(node.children, OctreeNode(
                    node.x.min + len * ((i - 1) % 2),
                    node.y.min + len * ((i - 1) % 4 >= 2),
                    node.z.min + len * (i > 4),
                    len,
                ))
                if in_range(centroid, node.children[i].extent)
                    insert_triangle!(node.children[i], triangle, centroid, max_depth - 1)
                end
                if in_range(centroid2, node.children[i].extent)
                    insert_triangle!(node.children[i], node.triangles[1], centroid2, max_depth - 1)
                end
            end
            empty!(node.triangles)
        else
            push!(node.triangles, triangle)
        end
    end
end
