function print_image(image::Array)
    # image is an array of floats ∈ [0, 1]

    CHARS = ".:-=+*#%@"
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            ind = Int(round(image[i, j] * (length(CHARS) - 1) + 1))
            print(CHARS[ind])
        end
        println()
    end
end

function save_image(image::Array, filename::String)
    gimg = colorview(Gray, image)
    save(filename, gimg)
end