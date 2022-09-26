module RayJL

include("linalg.jl")
export Vec3, Mat44, camera_mat44, from_rgb, normalize

# materials
include("materials/material_t.jl")
include("materials/diffuse.jl")
include("materials/reflect.jl")
include("materials/refract.jl")
export Material, Reflect, Diffuse, Refract

# bounding volume hierarchy
include("bvh/extent.jl")

# objects
include("objects/object_t.jl")
include("objects/sphere.jl")
include("objects/triangle.jl")
include("objects/polymesh.jl")
export Object, Sphere, Triangle, load_obj!

include("bvh/octree.jl")
include("bvh/bvh.jl")

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
export render

# visualize
include("visualize.jl")
export save_ppm, save_png

end # module RayJL