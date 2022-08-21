import Base: *

struct Vec3
    x::Float64
    y::Float64
    z::Float64
end

# pretty printing
function Base.show(io::IO, v::Vec3)
    @printf(io, "(%.4f, %.4f, %.4f)", v.x, v.y, v.z)
end

# arithmetic functions
function Base.:+(a::Vec3, b::Vec3)::Vec3
    return Vec3(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Base.:-(a::Vec3, b::Vec3)::Vec3
    return Vec3(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Base.:*(a::Vec3, b::Vec3)::Vec3
    # cross product
    return Vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function Base.:*(v::Vec3, x::Float64)::Vec3
    return Vec3(v.x * x, v.y * x, v.z * x)
end

function Base.:*(x::Float64, v::Vec3)::Vec3
    return Vec3(v.x * x, v.y * x, v.z * x)
end

function Base.:/(v::Vec3, x::Float64)::Vec3
    return Vec3(v.x / x, v.y / x, v.z / x)
end

# other functions
function distance(a::Vec3, b::Vec3)::Float64
    return sqrt((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)
end

function dot(scalar::Float64, vec::Vec3)::Float64
    return scalar * vec.x + vec.y * scalar + vec.z * scalar
end

function dot(v1::Vec3, v2::Vec3)::Float64
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function normalize(v::Vec3)::Vec3
    mx = max(abs(v.x), abs(v.y), abs(v.z))
    return v / mx
end