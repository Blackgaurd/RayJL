struct SolidColor <: Texture
    color::Color

    reflect::Bool

    SolidColor(red::Int, green::Int, blue::Int) = new(Color(red, green, blue), false)
    SolidColor(color::Color) = new(color, false)
end

function get_color(texture::SolidColor)::Color
    return texture.color
end
