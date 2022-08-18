module RayJL

println("Loading packages...")
using Images
using Printf
println("Packages loaded.")

include("vec3.jl")
include("ray.jl")

include("objects/sphere.jl")
include("objects/wall.jl")

include("visualize.jl")

function shoot_ray(ray::Ray3D, objects::Array, previous_obj::Int64=-1)
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
        return 0
    end

    # ray hits an object with 0 reflectance
    obj = objects[first_object_ind]
    if obj.ref == 0
        return obj.b
    end

    # ray hits an object with non-zero reflectance
    intersection = point(ray, first_intersection)
    normal = find_normal(obj, intersection)
    reflected_vec = find_reflection(ray, normal)
    reflected_ray = Ray3D(intersection, reflected_vec)
    return obj.ref * shoot_ray(reflected_ray, objects, first_object_ind)
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

    image = zeros(IMG_CELL_DIMS)

    for i = 1:IMG_CELL_DIMS[1]
        for j = 1:IMG_CELL_DIMS[2]
            i2 = IMG_CELL_DIMS[1] - i + 1
            y = CELL_DIM * (i2 - 1) + CELL_DIM / 2 - IMG_REAL_DIMS[1] / 2
            z = CELL_DIM * (j - 1) + CELL_DIM / 2 - IMG_REAL_DIMS[2] / 2

            ray = ray_from_points(CAMERA_POS, Vec3(DIS_TO_IMG + CAMERA_POS.x, y, z))
            image[i, j] = shoot_ray(ray, objects)
        end
    end

    return image
end

objects = [
    Sphere(Vec3(0, 0.3, 1), 3, 0.5, 0), # top right sphere
    Sphere(Vec3(-1, -4.2, -3), 2.5, 0.7, 0.5), # bottom left sphere
    #Sphere(Vec3(2, 4, -4.2), 1.9, 0.9, 0.5), # top left sphere
    #Sphere(Vec3(2, 4, 5.3), 1.9, 0.3, 0.5), # top right back square
    Wall(Vec3(0, 1, 0), Vec3(0, -10, 0), 0, 1),
    Wall(Vec3(0, -1, 0), Vec3(0, 10, 0), 0, 0.9),
    Wall(Vec3(0, 0, 1), Vec3(0, 0, -10), 0, 0.8),
    Wall(Vec3(0, 0, -1), Vec3(0, 0, 10), 0, 0.7),
    Wall(Vec3(-1, 0, 0), Vec3(10, 0, 0), 0, 0.6),
]

t = time()
image = raytrace(objects)
dt = time() - t
@printf("Time: %.2fs\n", dt)
save_image(image, "ray2.png")

end # module RayJL
