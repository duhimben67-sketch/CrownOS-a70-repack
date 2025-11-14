import os
import requests

TOKEN = os.environ['GITHUB_TOKEN']
REPO = "duhimben67-sketch/CrownOS-a70-repack"

api = f"https://api.github.com/repos/{REPO}/releases/latest"
headers = {
    "Authorization": f"token {TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

print("📥 Fetching latest release...")

r = requests.get(api, headers=headers)
if r.status_code != 200:
    print("❌ Could not fetch release info.")
    print(r.text)
    exit(1)

data = r.json()
assets = data.get("assets", [])

base_zip = None
for a in assets:
    if "lineage-base.zip" in a["name"]:
        base_zip = a
        break

if not base_zip:
    print("❌ lineage-base.zip not found in release.")
    exit(1)

url = base_zip["browser_download_url"]
print(f"Downloading {url}")

file = "base.zip"
with open(file, "wb") as f:
    f.write(requests.get(url).content)

print("✅ base.zip downloaded.")
