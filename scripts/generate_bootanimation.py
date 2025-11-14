import os, zipfile

out = "work/system/media/bootanimation.zip"

os.makedirs(os.path.dirname(out), exist_ok=True)

with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.writestr("desc.txt", "1080 2400 30\np 1 0 part0")
    z.writestr("part0/dummy.txt", "placeholder")

print("Generated placeholder bootanimation.")
