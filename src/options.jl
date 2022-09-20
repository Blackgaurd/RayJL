struct Resolution
    w::Real
    h::Real
end

struct Settings
    background_color::Vec3
    resolution::Resolution
    distance_to_image::Float32
    fov::Float32
    bias::Float32
end