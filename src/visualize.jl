using PyCall

function __init__()
    py"""
    import struct
    import zlib

    def png_pack(png_tag, data):
        chunk_head = png_tag + data
        return (
            struct.pack("!I", len(data))
            + chunk_head
            + struct.pack("!I", 0xFFFFFFFF & zlib.crc32(chunk_head))
        )


    def write_png(buf, width, height):
        # https://stackoverflow.com/a/19174800/14277568

        width_byte_4 = width * 4
        raw_data = b"".join(
            b"\x00" + buf[span : span + width_byte_4]
            for span in range((height - 1) * width_byte_4, -1, -width_byte_4)
        )

        return b"".join(
            [
                b"\x89PNG\r\n\x1a\n",
                png_pack(b"IHDR", struct.pack("!2I5B", width, height, 8, 6, 0, 0, 0)),
                png_pack(b"IDAT", zlib.compress(raw_data, 9)),
                png_pack(b"IEND", b""),
            ]
        )


    def to_abgr(v):
        r, g, b = map(lambda x: round(x * 255), (v.x, v.y, v.z))
        return 255 << 24 | b << 16 | g << 8 | r


    def save_png(img, filename):
        flat = []
        for row in reversed(img):
            flat.extend([to_abgr(c) for c in row])

        buf = b"".join([struct.pack("<I", i32) for i32 in flat])
        data = write_png(buf, len(img[0]), len(img))
        with open(filename, "wb") as f:
            f.write(data)
    """
end

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

function save_png(img::Matrix{Vec3}, filename::String)
    py"save_png"(img, filename)
end