module RayJL

using ProgressMeter

include("linalg.jl")
export Vec3, Mat44, camera_mat44, from_rgb, normalize

# materials
include("materials/material_t.jl")
include("materials/diffuse.jl")
include("materials/reflect.jl")
include("materials/refract.jl")
export Material, Reflect, Diffuse, Refract

# objects
include("objects/object_t.jl")
include("objects/sphere.jl")
include("objects/triangle.jl")
include("objects/polymesh.jl")
export Object, Sphere, Triangle, load_obj!

# bounding volume hierarchy
include("bvh/extent.jl")
include("bvh/octree.jl")
include("bvh/bvh.jl")
export Extents, build_octree, load_obj

# lights
include("lights/light_t.jl")
include("lights/directional.jl")
include("lights/point.jl")
export Light, DirectionalLight, PointLight

# options
include("options.jl")
export Resolution, Settings

# render
include("render.jl")
include("bvh/bvh_render.jl")
export render, bvh_render

# visualize
include("visualize.jl")
export save_ppm, save_png

end # module RayJL