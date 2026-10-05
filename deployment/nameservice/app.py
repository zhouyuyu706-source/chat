"""Zova signed username directory. GPL-3.0-or-later.

Wire format: daemon/src/jamidht/namedirectory.cpp. This is a separate
namespace, not a copy of Jami's directory and not an Ethereum service.
"""
import base64
import hashlib
import json
import logging
import os
import re
import sqlite3
from http import HTTPStatus
from cryptography.exceptions import InvalidSignature
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding, rsa

NAME = re.compile(r"[a-z0-9_-]{3,32}\Z")
ADDRESS = re.compile(r"[0-9a-f]{40}\Z")
MAX_BODY = 16384


def verified_record(name, data):
    if not NAME.fullmatch(name) or not isinstance(data, dict):
        raise ValueError("Invalid registration")
    addr = data.get("addr", "").removeprefix("0x").lower()
    if not ADDRESS.fullmatch(addr):
        raise ValueError("Invalid address")
    key_bytes = base64.b64decode(data["publickey"], validate=True)
    signature = base64.b64decode(data["signature"], validate=True)
    loader = serialization.load_pem_public_key if key_bytes.startswith(b"-----BEGIN") else serialization.load_der_public_key
    key = loader(key_bytes)
    if not isinstance(key, rsa.RSAPublicKey) or not 2048 <= key.key_size <= 8192:
        raise ValueError("Unsupported public key")
    der = key.public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
    # GnuTLS gnutls_pubkey_get_key_id(flags=0), not SHA1 of PKCS#1.
    if hashlib.sha1(der).hexdigest() != addr:
        raise InvalidSignature("Public key does not own this address")
    key.verify(signature, name.encode("ascii"), padding.PKCS1v15(), hashes.SHA512())
    return {"name": name, "addr": addr, "publickey": data["publickey"], "signature": data["signature"]}


class Directory:
    def __init__(self, db_path):
        self.db_path = db_path
        with self.connect() as db:
            db.execute("PRAGMA journal_mode=WAL")
            db.execute("CREATE TABLE IF NOT EXISTS names (name TEXT PRIMARY KEY, addr TEXT UNIQUE NOT NULL, publickey TEXT NOT NULL, signature TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)")

    def connect(self):
        db = sqlite3.connect(self.db_path, timeout=5)
        db.row_factory = sqlite3.Row
        return db

    def register(self, name, data):
        record = verified_record(name, data)
        with self.connect() as db:
            db.execute("BEGIN IMMEDIATE")
            existing = db.execute("SELECT addr FROM names WHERE name=?", (name,)).fetchone()
            if existing:
                return (200, {"success": True}) if existing["addr"] == record["addr"] else (409, {"success": False})
            try:
                db.execute("INSERT INTO names(name,addr,publickey,signature) VALUES(:name,:addr,:publickey,:signature)", record)
            except sqlite3.IntegrityError:
                return 409, {"success": False}
        return 200, {"success": True}

    def lookup(self, kind, value):
        column = "name" if kind == "name" else "addr"
        pattern = NAME if kind == "name" else ADDRESS
        if not pattern.fullmatch(value):
            return 400, {"error": "Invalid lookup"}
        with self.connect() as db:
            row = db.execute("SELECT name,addr,publickey,signature FROM names WHERE " + column + "=?", (value,)).fetchone()
        return (200, dict(row)) if row else (404, {"error": "Not found"})

    def __call__(self, env, start_response):
        status, result = 404, {"error": "Not found"}
        try:
            path = env.get("PATH_INFO", "").split("/")
            method = env.get("REQUEST_METHOD", "GET")
            if env.get("PATH_INFO") == "/health" and method == "GET":
                with self.connect() as db:
                    db.execute("SELECT 1 FROM names LIMIT 1").fetchall()
                status, result = 200, {"status": "ok", "service": "zova-names"}
            elif len(path) == 3 and path[1] in ("name", "addr"):
                kind, value = path[1], path[2].lower()
                if method == "GET":
                    status, result = self.lookup(kind, value)
                elif method == "POST" and kind == "name":
                    size = int(env.get("CONTENT_LENGTH") or 0)
                    if not 0 < size <= MAX_BODY:
                        status, result = 413, {"error": "Invalid body size"}
                    else:
                        data = json.loads(env["wsgi.input"].read(size))
                        status, result = self.register(value, data)
                else:
                    status, result = 405, {"error": "Method not allowed"}
        except InvalidSignature:
            status, result = 401, {"error": "Invalid signature"}
        except (ValueError, TypeError, KeyError, AttributeError, UnicodeError):
            status, result = 400, {"error": "Invalid request"}
        except sqlite3.Error:
            logging.exception("Directory database unavailable")
            status, result = 503, {"error": "Service unavailable"}
        body = json.dumps(result, separators=(",", ":")).encode("utf-8")
        start_response(f"{status} {HTTPStatus(status).phrase}", [("Content-Type", "application/json"), ("Content-Length", str(len(body))), ("Cache-Control", "no-store"), ("X-Content-Type-Options", "nosniff")])
        return [body]


def create_app():
    return Directory(os.environ.get("ZOVA_NAMES_DB", "/data/zova/names/names.sqlite3"))
