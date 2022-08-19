function print_image(image::Array{Color})
    # image is an array of Color objects

    CHARS = ".:-=+*#%@"
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            ind = Int(round(grayscale(image[i, j]) / 255 * (length(CHARS) - 1) + 1))
            print(CHARS[ind])
        end
        println()
    end
end

function save_image(image::Array{Color}, filename::String)
    # image is an array of Color objects
    imgc = Array{RGB}(undef, size(image, 1), size(image, 2))
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            imgc[i, j] = RGB{Float32}(
                image[i, j].r / 255,
                image[i, j].g / 255,
                image[i, j].b / 255
            )
        end
    end
    save(filename, imgc)
end
