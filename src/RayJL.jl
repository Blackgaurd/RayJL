module RayJL

include("linalg.jl")

# materials
include("materials/material_t.jl")
include("materials/diffuse.jl")
include("materials/reflect.jl")

# objects
include("objects/object_t.jl")
include("objects/sphere.jl")

# lights
include("lights/light_t.jl")
include("lights/directional.jl")

# options
include("options.jl")

# render
include("render.jl")

export render

end # module RayJL