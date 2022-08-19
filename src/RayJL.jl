module RayJL

println("Loading packages...")
using Images
using Printf
println("Packages loaded.")

include("color.jl")
include("vec3.jl")
include("ray.jl")

include("textures/texture_t.jl")
include("textures/solid_color.jl")
include("textures/mirror.jl")
include("textures/tinted_mirror.jl")

include("objects/object_t.jl")
include("objects/sphere.jl")
include("objects/wall.jl")

include("visualize.jl")

function shoot_ray(ray::Ray3D, objects::Array, previous_obj::Int64=-1)::Color
    # recursively shoots a ray until it either
    # hits an object with 0 reflectance or doesn't hit anything
    # returns the concentration of light that hits the object
    # or 0 if the ray doesn't hit anything

    first_intersection = 1e18
    first_object_ind = -1
    for (i, obj) in enumerate(objects)
        if i == previous_obj
            continue
        end

        intersect, t = find_intersection(obj, ray)
        if intersect && t < first_intersection
            first_intersection = t
            first_object_ind = i
        end
    end

    # ray doesn't hit anything
    if first_object_ind == -1
        return Color(0, 0, 0)
    end

    obj = objects[first_object_ind]

    if !obj.texture.reflect
        # ray hits an object with texture
        # that doesn't reflect light
        return get_color(obj.texture) * ray.intensity
    end

    # ray hits an object with texture
    # that does reflect light
    intersection = point(ray, first_intersection)
    normal = find_normal(obj, intersection)
    reflected_dir = find_reflection(ray, normal)
    reflected_ray = Ray3D(intersection, reflected_dir, ray.color, ray.intensity)
    reflected_ray = apply_reflectance(obj.texture, reflected_ray)
    return shoot_ray(reflected_ray, objects, first_object_ind)
end

function raytrace(objects::Array)
    # for now camera will be facing positive x direction
    CAMERA_POS = Vec3(-25, 0, 0)
    DIS_TO_IMG = 1
    IMG_CELL_DIMS = (1440, 2560)
    FOV = deg2rad(40)

    img_real_w = 2 * DIS_TO_IMG * tan(FOV / 2)
    IMG_REAL_DIMS = (
        img_real_w,
        img_real_w * IMG_CELL_DIMS[2] / IMG_CELL_DIMS[1]
    )

    CELL_DIM = IMG_REAL_DIMS[1] / IMG_CELL_DIMS[1]

    image = Array{Color}(undef, IMG_CELL_DIMS[1], IMG_CELL_DIMS[2])

    for i = 1:IMG_CELL_DIMS[1]
        for j = 1:IMG_CELL_DIMS[2]
            i2 = IMG_CELL_DIMS[1] - i + 1
            y = CELL_DIM * (i2 - 1) + CELL_DIM / 2 - IMG_REAL_DIMS[1] / 2
            z = CELL_DIM * (j - 1) + CELL_DIM / 2 - IMG_REAL_DIMS[2] / 2

            ray = ray_from_points(CAMERA_POS, Vec3(DIS_TO_IMG + CAMERA_POS.x, y, z), Color(255, 255, 255), 1)
            if i == 14 && j == 160
                shoot_ray(ray, objects)
            end
            image[i, j] = shoot_ray(ray, objects)
        end
    end

    return image
end

objects = [
    Sphere(Vec3(0, 0, 0), 1, SolidColor(255, 255, 255)),
]

start = time()
image = raytrace(objects)
@printf("Time: %.2fs\n", time() - start)
save_image(image, "test.png")

end # module RayJL
