using RayJL

function main()
    settings = Settings(
        from_rgb(255, 254, 188),
        Resolution(1920, 1080),
        1.0,
        70.0,
        1e-4
    )

    objects::Array{Object,1} = [
        Sphere(Vec3(0, -100, 0), 98, Diffuse(from_rgb(255, 255, 255))),
    ]
    load_obj("examples/torus/torus.obj", from_rgb(255, 255, 240), objects)
    lights::Array{Light,1} = [
        PointLight(Vec3(0, 0, 0), from_rgb(0, 255, 0), 1),
        PointLight(Vec3(3, 1, 3), from_rgb(255, 0, 0), 1),
    ]

    look_from = Vec3(4, 3, 2)
    look_at = Vec3(2, 0.5, 0)

    println("Rendering $(size(objects)[1]) objects...")
    start = time()
    image = render(look_from, look_at, objects, lights, settings, 2, 5)
    println("Done in $(time() - start) seconds.")

    save_png(image, "examples/torus/image.png")
    println("Saved image to examples/torus/image.png")
end

main()