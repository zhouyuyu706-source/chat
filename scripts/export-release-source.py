"""Export working-tree source, not stale Git HEAD; never export local secrets."""
import argparse
import hashlib
from pathlib import Path
import subprocess
import tarfile

parser = argparse.ArgumentParser()
parser.add_argument("--git", required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--version", default="0.2.2")
args = parser.parse_args()
root = Path(__file__).resolve().parent.parent
output = Path(args.output)
if output.exists():
    raise SystemExit("Existing source archive preserved")
repos = [root] + [root / name for name in ("daemon", "lrc", "client-qt", "client-android", "client-ios", "client-macosx", "plugins")]
blocked_parts = {".git", ".gradle", ".cxx", "build", "x64", "unstripped", "node_modules", "__pycache__", "downloads"}
blocked_suffixes = {".log", ".apk", ".msi", ".pdb", ".ilk", ".obj", ".o", ".pyc", ".jks", ".keystore", ".p12", ".pfx"}
files = set()
for repo in repos:
    if not (repo / ".git").exists():
        continue
    listing = subprocess.check_output([args.git, "-C", str(repo), "ls-files", "-z", "--cached", "--others", "--exclude-standard"])
    for name in listing.decode("utf-8").split("\0"):
        if not name:
            continue
        path = repo / name
        rel = path.relative_to(root)
        if not path.is_file() or path.is_symlink():
            continue
        if any(part in blocked_parts for part in rel.parts) or path.suffix.lower() in blocked_suffixes:
            continue
        if path.name in {"local.properties", "keystore.bin", "google-services.json", ".env", "android-host-diagnostic.json"}:
            continue
        if path.name.lower() in {"password.txt", "credentials.json", "id_rsa", "id_ed25519"}:
            continue
        if rel.as_posix() == "deployment/HANDOFF.md" or "review_information" in rel.parts:
            continue
        # Ignore generated top-level build logs and scratch outputs.
        if len(rel.parts) == 1 and path.suffix.lower() in {".json", ".zip", ".gz", ".exe", ".dll"}:
            continue
        files.add(path)
required = ["daemon/src/jamidht/jamiaccount.cpp", "client-android/ring-android/vendor/flexbox/LICENSE", "client-android/ring-android/vendor/shaperipple/LICENSE", "deployment/RELEASE-0.2.2.md", "scripts/build-zova-windows.ps1", "COPYING"]
for name in required:
    if root / name not in files:
        raise SystemExit("Required source missing: " + name)
output.parent.mkdir(parents=True, exist_ok=True)
with tarfile.open(output, "w:gz") as archive:
    for path in sorted(files):
        archive.add(path, arcname="Zova-" + args.version + "-source/" + path.relative_to(root).as_posix(), recursive=False)
with tarfile.open(output, "r:gz") as archive:
    assert len(archive.getmembers()) == len(files)
print(f"Exported {len(files)} working-tree files; {output.stat().st_size} bytes")
print(hashlib.sha256(output.read_bytes()).hexdigest(), output.name)
