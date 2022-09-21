function save_ppm(img::Matrix{Vec3}, filename::String)
    open(filename, "w") do f
        println(f, "P3")
        println(f, size(img, 2), " ", size(img, 1))
        println(f, 255)
        for i in 1:size(img, 1)
            for j in 1:size(img, 2)
                println(f, round(255 * img[i, j].x), " ", round(255 * img[i, j].y), " ", round(255 * img[i, j].z))
            end
        end
    end
end