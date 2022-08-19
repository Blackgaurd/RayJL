struct Color
    r::UInt8
    g::UInt8
    b::UInt8
end

function mix(a::Color, b::Color)::Color
    return Color(
        (a.r + b.r) / 2,
        (a.g + b.g) / 2,
        (a.b + b.b) / 2
    )
end

function grayscale(c::Color)::UInt8
    # based on the luminosity method
    return UInt8(round(0.3 * c.r + 0.59 * c.g + 0.11 * c.b))
end

function Base.:*(c::Color, x::Float64)::Color
    return Color(round(c.r * x), round(c.g * x), round(c.b * x))
end

function Base.:*(x::Float64, c::Color)::Color
    return Color(round(x * c.r), round(x * c.g), round(x * c.b))
end
