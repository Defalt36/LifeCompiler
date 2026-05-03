import sys
import os
from PIL import Image, ImageDraw, ImageFont

format = '32_32'
fontSize = 24
overlay_path = None

if len(sys.argv) == 2:
    format = sys.argv[1]
elif len(sys.argv) == 3:
    format = sys.argv[1]
    overlay_path = sys.argv[2]
elif len(sys.argv) == 4:
    format = sys.argv[1]
    overlay_path = sys.argv[2]
    fontSize = int(sys.argv[3])

font_folder = "fonts"
fonts = [f for f in os.listdir(font_folder) if f.lower().endswith(('.ttf', '.otf'))]

if not fonts:
    print("No fonts found in 'fonts/' folder.")
    sys.exit(1)

print("[ Available fonts ]")
for i, font in enumerate(fonts, start=1):
    print(f"{i}. {font}")

choice = int(input("Select font number: "))

if choice < 1 or choice > len(fonts):
    print("Invalid font selection.")
    sys.exit(1)

fontFile = os.path.join(font_folder, fonts[choice - 1])

if format == '32_64':
    canvasSize = (512, 1024)
    new_canvas = Image.open('files/grid.png').convert("RGBA")
    distance_x = 32
    distance_y = 64
    offset_x = 16
    offset_y = 48
elif format == '32_32':
    canvasSize = (512, 512)
    new_canvas = Image.new('RGBA', canvasSize, color="black")
    distance_x = 32
    distance_y = 32
    offset_x = 16
    offset_y = 16
else:
    print("Invalid format. Use 32_32 or 32_64.")
    sys.exit(1)

working_canvas = ImageDraw.Draw(new_canvas)
loadedFont = ImageFont.truetype(fontFile, fontSize)

print(f"[ Drawing table with {fonts[choice - 1]}... ]")

with open('files/custom_table.txt', mode='r', encoding='utf-8') as file:
    table = file.read()

index = 0
for character in table:
    if character == '\n':
        continue

    x_position = (distance_x * (index % 16)) + offset_x
    y_position = (distance_y * (index // 16)) + offset_y

    working_canvas.text(
        (x_position, y_position),
        character,
        fill='white',
        font=loadedFont,
        anchor='mm'
    )

    index += 1

# === Overlay logic ===
if overlay_path:
    overlay_full_path = os.path.join("files", overlay_path)

    if not os.path.exists(overlay_full_path):
        print("Overlay image not found.")
        sys.exit(1)

    overlay_img = Image.open(overlay_full_path).convert("RGBA")

    # Resize overlay to match canvas (remove this if you want original size)
    overlay_img = overlay_img.resize(canvasSize)

    # Paste using alpha channel (keeps transparency)
    new_canvas.paste(overlay_img, (0, 0), overlay_img)

print("[ Done. ]")

os.makedirs("output", exist_ok=True)
new_canvas.save("output/canvas.png")
