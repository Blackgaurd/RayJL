using RayJL

function main()
    settings = Settings(from_rgb(102, 255, 255), Resolution(1920, 1080), 1, 70, 1e-4)
    objects::Array{Object,1} = [
        Sphere(Vec3(0, -10000, 0), 10000, Diffuse(from_rgb(23, 194, 132))),
    ]

    dim = 20
    for i in 1:dim
        for j in 1:dim
            radius = 1 - (i + j) / (dim * 2)
            origin = Vec3(
                -dim / 2 + i + 0.5,
                radius,
                -dim / 2 + j + 0.5,
            )
            color = from_rgb(
                rand((0, 255)),
                rand((0, 255)),
                rand((0, 255)),
            )
            push!(objects, Sphere(origin, radius, Diffuse(color)))
        end
    end

    lights::Array{Light,1} = [
        DirectionalLight(Vec3(0.5, -0.5, 0.5), from_rgb(255, 255, 255), 1),
        DirectionalLight(Vec3(-0.5, -0.5, -0.5), from_rgb(255, 255, 255), 1),
    ]

    look_from = Vec3(25, 7, -3)
    look_at = Vec3(0, 0, 0)

    start = time()
    image = render(look_from, look_at, objects, lights, settings, 1, 5)
    println("Completed in $(time() - start) seconds")

    save_png(image, "examples/grid/image.png")
end

main()