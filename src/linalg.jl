function float_eq(a::Float32, b::Float32)::Bool
    abs(a - b) < 1e-6
end

struct Vec3
    x::Float32
    y::Float32
    z::Float32
end

# vec3 functions
function dot(a::Vec3, b::Vec3)::Float32
    return a.x * b.x + a.y * b.y + a.z * b.z
end
function cross(a::Vec3, b::Vec3)::Vec3
    return Vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end
function norm(a::Vec3)::Float32
    return sqrt(dot(a, a))
end
function normalize(a::Vec3)::Vec3
    return a / norm(a)
end
function abs(a::Vec3)::Vec3
    Vec3(abs(a.x), abs(a.y), abs(a.z))
end

⋅(a::Vec3, b::Vec3) = dot(a, b)
×(a::Vec3, b::Vec3) = cross(a, b)

# vec3 arithmetic operators
function Base.:+(a::Vec3, b::Vec3)::Vec3
    Vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end
function Base.:+(a::Vec3, b::Real)::Vec3
    Vec3(a.x + b, a.y + b, a.z + b)
end
function Base.:-(a::Vec3, b::Vec3)::Vec3
    Vec3(a.x - b.x, a.y - b.y, a.z - b.z)
end
function Base.:-(a::Vec3, b::Real)::Vec3
    Vec3(a.x - b, a.y - b, a.z - b)
end
function Base.:*(a::Vec3, b::Vec3)::Vec3
    Vec3(a.x * b.x, a.y * b.y, a.z * b.z)
end
function Base.:*(a::Vec3, b::Real)::Vec3
    Vec3(a.x * b, a.y * b, a.z * b)
end
function Base.:/(a::Vec3, b::Vec3)::Vec3
    Vec3(a.x / b.x, a.y / b.y, a.z / b.z)
end
function Base.:/(a::Vec3, b::Real)::Vec3
    Vec3(a.x / b, a.y / b, a.z / b)
end

# vec3 comparison operators
function Base.:(==)(a::Vec3, b::Vec3)::Bool
    float_eq(a.x, b.x) && float_eq(a.y, b.y) && float_eq(a.z, b.z)
end

struct Mat44
    arr::Matrix{Float32}

    Mat44() = begin
        # create identity matrix
        arr = zeros(Float32, 4, 4)
        for i in 1:4
            arr[i, i] = 1.0
        end
    end
end

# mat44 functions
function camera_mat44(look_from::Vec3, look_at::Vec3, up::Vec3=Vec3(0.0, 1.0, 0.0))::Mat44
    forward = (look_from - look_at) |> normalize

    if abs(forward) == abs(up)
        error("forward vector is parallel to up vector")
    end

    right = cross(up, forward) |> normalize
    newup = cross(forward, right) |> normalize

    ret = Mat44()

    ret.arr[1, 1] = right.x
    ret.arr[1, 2] = right.y
    ret.arr[1, 3] = right.z

    ret.arr[2, 1] = newup.x
    ret.arr[2, 2] = newup.y
    ret.arr[2, 3] = newup.z

    ret.arr[3, 1] = forward.x
    ret.arr[3, 2] = forward.y
    ret.arr[3, 3] = forward.z

    ret.arr[4, 1] = look_from.x
    ret.arr[4, 2] = look_from.y
    ret.arr[4, 3] = look_from.z

    ret
end
function transform_point(mat::Mat44, vec::Vec3)::Vec3
    ret = Vec3(
        vec.x * mat.arr[1][1] + vec.y * mat.arr[2][1] + vec.z * mat.arr[3][1],
        vec.x * mat.arr[1][2] + vec.y * mat.arr[2][2] + vec.z * mat.arr[3][2],
        vec.x * mat.arr[1][3] + vec.y * mat.arr[2][3] + vec.z * mat.arr[3][3]
    )
    w = vec.x * mat.arr[1][4] + vec.y * mat.arr[2][4] + vec.z * mat.arr[3][4]

    w == 0 ? ret : ret / w
end
function transform_dir(mat::Mat44, vec::Vec3)::Vec3
    Vec3(
        vec.x * mat.arr[1][1] + vec.y * mat.arr[2][1] + vec.z * mat.arr[3][1],
        vec.x * mat.arr[1][2] + vec.y * mat.arr[2][2] + vec.z * mat.arr[3][2],
        vec.x * mat.arr[1][3] + vec.y * mat.arr[2][3] + vec.z * mat.arr[3][3]
    )
end

# mat44 arithmetic operators
function Base.:*(a::Mat44, b::Mat44)::Mat44
    ret = Mat44()
    for i in 1:4
        for j in 1:4
            ret.arr[i][j] = 0
            for k in 1:4
                ret.arr[i][j] += a.arr[i][k] * b.arr[k][j]
            end
        end
    end
    ret
end