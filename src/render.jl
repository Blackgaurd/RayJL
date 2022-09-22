function check_interference(ray_o::Vec3, ray_d::Vec3, objects::Array{Object, 1}, source_ind::Int)::Bool
    for (i, obj) in enumerate(objects)
        if i == source_ind || !(typeof(obj.material) == Diffuse)
            continue
        end
        intersect, _ = find_intersect(obj, ray_o, ray_d)
        if intersect
            return true
        end
    end
    return false
end

function cast_ray(ray_o::Vec3, ray_d::Vec3, objects::Array{Object, 1}, lights::Array{Light, 1}, settings::Settings, max_depth::Int)::Vec3
    if max_depth == 0
        return settings.background_color
    end

    closest_t = Inf32
    obj_ind = -1
    for (i, obj) in enumerate(objects)
        intersect, t = find_intersect(obj, ray_o, ray_d)
        if intersect && t < closest_t
            closest_t = t
            obj_ind = i
        end
    end

    if obj_ind == -1
        return settings.background_color
    end

    obj = objects[obj_ind]
    intersect_p = ray_o + ray_d * closest_t
    normal = find_normal(obj, ray_d, intersect_p)
    bias = normal * settings.bias

    hit_color = Vec3(0.0, 0.0, 0.0)

    if typeof(obj.material) == Diffuse
        for light in lights
            light_dir = direction_at(light, intersect_p)

            # shadows
            if check_interference(intersect_p + bias, light_dir, objects, obj_ind)
                continue
            end

            hit_color += obj.material.albedo / pi * light.intensity * light.color * max(0.0, dot(normal, light_dir))
        end

    elseif typeof(obj.material) == Reflect
        reflect_d = reflect(ray_d, normal)
        # todo: change 0.8 to a value in settings
        hit_color += cast_ray(intersect_p + bias, reflect_d, objects, lights, settings, max_depth - 1) * 0.8

    elseif typeof(obj.material) == Refract
        refact_k = fresnel(ray_d, normal, obj.material.ior)

        refract_color = Vec3(0.0, 0.0, 0.0)
        if refract_k < 1
            refract_d = refract(ray_d, normal, obj.material.ior)
            refract_color = cast_ray(intersect_p - bias, refract_d, objects, lights, settings, max_depth - 1)
        end

        reflect_d = reflect(ray_d, normal)
        reflect_color = cast_ray(intersect_p + bias, reflect_d, objects, lights, settings, max_depth - 1)

        hit_color += reflect_color * refract_k + refract_color * (1 - refract_k)
    end

    hit_color
end

function render(look_from::Vec3, look_at::Vec3, objects::Array{Object, 1}, lights::Array{Light, 1}, settings::Settings, anti_aliasing::Int, recursion_depth::Int, camera_up::Vec3=Vec3(0.0, 1.0, 0.0))::Matrix{Vec3}
    fov = deg2rad(settings.fov)
    img_res = settings.resolution
    world_res_w = 2 * settings.distance_to_image * tan(fov / 2)
    world_res = Resolution(world_res_w, world_res_w * img_res.h / img_res.w)
    cell_size = world_res.w / img_res.w

    img_res.w = Int(img_res.w)
    img_res.h = Int(img_res.h)

    image = fill(Vec3(0.0, 0.0, 0.0), img_res.h, img_res.w)

    camera = camera_mat44(look_from, look_at, camera_up)
    for i in 0:img_res.h-1
        for j in 0:img_res.w-1
            for a_i in 0:anti_aliasing-1
                for a_j in 0:anti_aliasing-1
                    ray_d = Vec3(
                        j * cell_size + (cell_size / anti_aliasing) * (a_j + 0.5) - world_res.w / 2,
                        (img_res.h - i) * cell_size + (cell_size / anti_aliasing) * (a_i + 0.5) - world_res.h / 2,
                        -settings.distance_to_image
                    ) |> normalize
                    ray_d = transform_dir(camera, ray_d)

                    image[i + 1, j + 1] += cast_ray(look_from, ray_d, objects, lights, settings, recursion_depth)
                end
            end
            image[i + 1, j + 1] /= anti_aliasing^2
        end
    end

    image
end
