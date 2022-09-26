using RayJL

function main()
    settings = Settings(from_rgb(102, 255, 255) * 0.8, Resolution(1920, 1080), 1, 70, 1e-4)
    objects::Array{Object,1} = [
        #Sphere(Vec3(0, 0, 0), 0.5, Diffuse(from_rgb(0, 0, 0))),
        #Sphere(Vec3(0, 0, -10), 0.5, Diffuse(from_rgb(255, 0, 0))),
        #Sphere(Vec3(-10, 0, 0), 0.5, Diffuse(from_rgb(0, 255, 0))),
        #Sphere(Vec3(0, -10, 0), 0.5, Diffuse(from_rgb(0, 0, 255))),
        Sphere(Vec3(0, 0, -10025), 10000, Reflect()),
    ]
    load_obj!("examples/toilet/toilet.obj", from_rgb(255, 255, 255), objects)
    lights::Array{Light,1} = [
        DirectionalLight(-Vec3(100, -30, 55) |> normalize, from_rgb(255, 255, 255), 1)
    ]
    look_from = Vec3(100, -30, 55) / 2
    look_at = Vec3(0, 0, -5)

    println(size(objects))

    start = time()
    image = render(look_from, look_at, objects, lights, settings, 2, 5, Vec3(0, 1, 0))
    println("Completed in $(time() - start) seconds")

    save_png(image, "examples/toilet/image.png")
end

main()