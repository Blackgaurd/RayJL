abstract type Material end

struct DummyMaterial <: Material
    DummyMaterial() = new()
end