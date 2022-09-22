module RayJL

include("linalg.jl")
export Vec3, Mat44, camera_mat44, from_rgb

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
export Object, Sphere, Triangle

# lights
include("lights/light_t.jl")
include("lights/directional.jl")
export Light, DirectionalLight

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