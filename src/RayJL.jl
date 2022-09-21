module RayJL

include("linalg.jl")
export Vec3, Mat44, camera_mat44

# materials
include("materials/material_t.jl")
include("materials/diffuse.jl")
include("materials/reflect.jl")
export Material, Reflect, Diffuse, reflect

# objects
include("objects/object_t.jl")
include("objects/sphere.jl")
export Object, Sphere, find_normal, find_intersect

# lights
include("lights/light_t.jl")
include("lights/directional.jl")
export Light, DirectionalLight, direction_at

# options
include("options.jl")
export Resolution, Settings

# render
include("render.jl")
export render

# visualize
include("visualize.jl")
export save_ppm

end # module RayJL