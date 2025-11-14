import os, sys, requests

repo = os.environ["REPO"]
token = os.environ["TOKEN"]

api = f"https://api.github.com/repos/{repo}/releases/latest"
h = {"Authorization": f"token {token}", "Accept": "application/vnd.github.v3+json"}

r = requests.get(api, headers=h)
if r.status_code != 200:
    print("No release found. Upload lineage-base.zip to a release.")
    sys.exit(1)

asset = None
for a in r.json().get("assets", []):
    if a["name"] == "lineage-base.zip":
        asset = a
        break

if asset is None:
    print("lineage-base.zip not found in latest release.")
    sys.exit(1)

dl = requests.get(asset["url"], headers={**h, "Accept": "application/octet-stream"})
open("lineage-base.zip", "wb").write(dl.content)
print("Downloaded lineage-base.zip")
