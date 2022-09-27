struct BVHNode
    extents::Extents
    triangles::Array{Triangle,1}
    children::Array{BVHNode,1}
end

function has_children(node::BVHNode)::Bool
    !isempty(node.children)
end

function has_triangles(node::BVHNode)::Bool
    !isempty(node.triangles)
end

function build_bvh(octree::OctreeNode)::BVHNode
    if has_children(octree)
        # not a leaf node
        child_bvh = BVHNode[]
        child_extents = Extents[]
        for child in octree.children
            child_bvh_node = build_bvh(child)
            push!(child_bvh, child_bvh_node)
            push!(child_extents, child_bvh_node.extents)
        end

        total_extents = Extents(child_extents)
        return BVHNode(total_extents, Triangle[], child_bvh)
    elseif has_triangles(octree)
        # leaf node with triangles
        total_extents = Extents(octree.triangles)
        return BVHNode(total_extents, octree.triangles, BVHNode[])
    else
        # empty leaf node
        return BVHNode(Extents(), Triangle[], BVHNode[])
    end
end

function bvh_intersect!(bvh::BVHNode, ray_o::Vec3, ray_d::Vec3, triangles::Array{Triangle,1})
    # find triangles that potentially intersect with the ray

    if !intersects_extent(bvh.extents, ray_o, ray_d)
        return
    end

    if has_children(bvh)
        # not a leaf node
        for child in bvh.children
            bvh_intersect!(child, ray_o, ray_d, triangles)
        end
    elseif has_triangles(bvh)
        # leaf node with triangles
        push!(triangles, bvh.triangles...)
    end
    nothing
end

function load_obj(filename::String, color::Vec3, max_depth::Int)::BVHNode
    triangles = Triangle[]
    load_obj!(filename, color, triangles)

    # build octree
    octree = build_octree(triangles, max_depth)

    # build bvh
    build_bvh(octree)
end