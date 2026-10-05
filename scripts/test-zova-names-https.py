"""Creates one clearly named QA record in the owned public directory."""
import base64
import hashlib
import json
import time
import urllib.request
import urllib.error
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa, padding

base = "https://zova.38-60-203-167.sslip.io/names"
name = "zova-qa-" + str(int(time.time()))
key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
der = key.public_key().public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
record = {"addr": hashlib.sha1(der).hexdigest(), "publickey": base64.b64encode(der).decode(), "signature": base64.b64encode(key.sign(name.encode(), padding.PKCS1v15(), hashes.SHA512())).decode()}

def request(path, data=None):
    req = urllib.request.Request(base + path, data=json.dumps(data).encode() if data else None, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=15) as response:
        return json.load(response)

assert request("/name/" + name, record)["success"]
assert request("/name/" + name)["addr"] == record["addr"]
assert request("/addr/" + record["addr"])["name"] == name
try:
    request("/name/" + name + "x", record)
    raise AssertionError("Forged signature was accepted")
except urllib.error.HTTPError as error:
    assert error.code == 401, error.code
print("PASS HTTPS signed registration, forward/reverse lookup, invalid signature rejection:", name)
