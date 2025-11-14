#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os,sys

W,H = 1080,2400
frames = 60
font_size = 140

workdir = sys.argv[1] if len(sys.argv)>1 else "."
out = os.path.join(workdir,"system","media")
os.makedirs(out,exist_ok=True)
part0 = os.path.join(workdir,"part0")
os.makedirs(part0,exist_ok=True)

bg=(0,0,0)
grey=(160,160,160)
white=(255,255,255)

# locate a usable font
font_paths = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/truetype/freefont/FreeSansBold.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"
]
font_path = None
for p in font_paths:
    if os.path.exists(p):
        font_path=p
        break

from PIL import ImageFont
if font_path:
    font = ImageFont.truetype(font_path, font_size)
else:
    font = ImageFont.load_default()

for i in range(frames):
    img = Image.new("RGB",(W,H),bg)
    draw = ImageDraw.Draw(img)
    # crown - simple polygon
    alpha = (i/30.0) if i<30 else 1.0
    crown_color = tuple(int(c*alpha) for c in grey)
    points = [(440,1050),(540,760),(640,1050),(750,820),(860,1050),(220,1050),(330,820),(440,1050)]
    draw.polygon(points, fill=crown_color)
    # shadow base
    draw.ellipse((420,1040,860,1100), outline=None, fill=(int(30*alpha),)*3)
    # text fade after frame 25
    if i>25:
        ta = (i-25)/30.0
        text = "Crown OS"
        w,h = draw.textsize(text,font=font)
        textcol = tuple(int(white[j]*ta) for j in range(3))
        draw.text(((W-w)/2,1250), text, font=font, fill=textcol)
    fname = os.path.join(part0,f"frame_{i:03d}.png")
    img.save(fname, "PNG")
# create desc.txt
with open(os.path.join(workdir,"desc.txt"),"w") as f:
    f.write("1080 2400 30\np 1 0 part0\n")
# zip into bootanimation.zip
import zipfile
ba = os.path.join(out,"bootanimation.zip")
with zipfile.ZipFile(ba,"w",compression=zipfile.ZIP_DEFLATED) as z:
    z.write(os.path.join(workdir,"desc.txt"), "desc.txt")
    for fn in sorted(os.listdir(part0)):
        z.write(os.path.join(part0,fn), os.path.join("part0",fn))
print("bootanimation.zip created at",ba)
