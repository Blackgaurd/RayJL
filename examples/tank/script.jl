using RayJL

function main()
    settings = Settings(
        from_rgb(255, 254, 188),
        Resolution(1920, 1080),
        1.0,
        70.0,
        1e-4
    )

    objects = Object[
        Sphere(Vec3(0, -10004, 0), 10000, Diffuse(Vec3(0.2, 0.2, 0.2))),
        #Sphere(Vec3(17, 0, 0), 0.5, Diffuse(from_rgb(0, 255, 0))),
        #Sphere(Vec3(0, 17, 0), 0.5, Diffuse(from_rgb(0, 0, 255))),
        #Sphere(Vec3(0, 0, 17), 0.5, Diffuse(from_rgb(255, 0, 0))),

        # back mirror
        Triangle(Vec3(20, -20, -30), Vec3(20, 20, -32), Vec3(-40, 20, -32), Reflect()),
        Triangle(Vec3(20, -20, -30), Vec3(-40, 20, -32), Vec3(-40, -20, -30), Reflect()),

        # side mirror
        Triangle(Vec3(60, 20, 20), Vec3(40, 20, -20), Vec3(35, -20, -20), Reflect()),
        Triangle(Vec3(60, 20, 20), Vec3(35, -20, -20), Vec3(55, -20, 20), Reflect()),
    ]
    load_obj!("examples/tank/tank.obj", from_rgb(255, 255, 240), objects)

    lights = Light[
        DirectionalLight(-Vec3(-20, 30, 45) |> normalize, from_rgb(255, 255, 255), 1)
        DirectionalLight(-Vec3(-20, 20, -15) |> normalize, from_rgb(255, 255, 255), 1)
    ]

    look_from = Vec3(-35, 27, 70)
    look_at = Vec3(0, 3, 0)

    println("Rendering $(size(objects)[1]) objects...")
    start = time()
    image = render(look_from, look_at, objects, lights, settings, 2, 5)
    println("Done in $(time() - start) seconds.")

    save_png(image, "examples/tank/image.png")
    println("Saved image to examples/tank/image.png")
end

main()