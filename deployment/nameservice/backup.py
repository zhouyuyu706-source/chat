"""Consistent online SQLite backup. Output stays outside the public website."""
import datetime
import os
from pathlib import Path
import sqlite3

os.umask(0o077)
root = Path("/data/zova/backups/names")
root.mkdir(parents=True, exist_ok=True)
target = root / (datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ") + ".sqlite3")
if target.exists():
    raise SystemExit("Backup already exists; refusing overwrite")
with sqlite3.connect("file:/data/zova/names/names.sqlite3?mode=ro", uri=True) as source:
    with sqlite3.connect(target) as destination:
        source.backup(destination)
        assert destination.execute("PRAGMA integrity_check").fetchone()[0] == "ok"
print("Verified database backup:", target.name)
