function load_obj!(filename::String, color::Vec3, objects::Array{Triangle,1})
    vertices::Array{Vec3,1} = []
    for line in eachline(filename)
        if startswith(line, "v ")
            v = split(line, " ")
            push!(vertices, Vec3(parse(Float32, v[2]), parse(Float32, v[3]), parse(Float32, v[4])))
        elseif startswith(line, "f ")
            f = split(line, " ")
            if size(f)[1] == 4
                # 3 vertices
                f[2] = split(f[2], "/")[1]
                f[3] = split(f[3], "/")[1]
                f[4] = split(f[4], "/")[1]
                push!(objects, Triangle(vertices[parse(Int, f[2])], vertices[parse(Int, f[3])], vertices[parse(Int, f[4])], Diffuse(color)))
            elseif size(f)[1] == 5
                # 4 vertices
                f[2] = split(f[2], "/")[1]
                f[3] = split(f[3], "/")[1]
                f[4] = split(f[4], "/")[1]
                f[5] = split(f[5], "/")[1]
                push!(objects, Triangle(vertices[parse(Int, f[2])], vertices[parse(Int, f[3])], vertices[parse(Int, f[4])], Diffuse(color)))
                push!(objects, Triangle(vertices[parse(Int, f[2])], vertices[parse(Int, f[4])], vertices[parse(Int, f[5])], Diffuse(color)))
            end
        end
    end
    nothing
end