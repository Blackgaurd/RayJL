struct BVHNode
    extents::Extents
    triangles::Array{Triangle,1}
    children::Array{BVHNode,1}
end