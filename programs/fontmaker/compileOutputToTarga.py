from PIL import Image, ImageOps
import os

input_file = "output/canvas.png"
output_file = "output/canvas.tga"

os.makedirs(os.path.dirname(output_file), exist_ok=True)

try:
    img = Image.open(input_file)

    # apply EXIF auto-orientation
    img = ImageOps.exif_transpose(img)

    # ensure correct format for TGA
    img = img.convert("RGBA")

    img.save(output_file, format="TGA")

    print("Done:", output_file)
except Exception as e:
    print("Conversion failed:", e)
