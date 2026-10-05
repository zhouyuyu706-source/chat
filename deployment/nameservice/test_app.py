import base64
import hashlib
import io
import json
import os
import tempfile
import unittest
from cryptography.exceptions import InvalidSignature
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding, rsa
from app import Directory, verified_record


class DirectoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.key = rsa.generate_private_key(public_exponent=65537, key_size=2048)

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.directory = Directory(os.path.join(self.temp.name, "names.db"))

    def tearDown(self):
        self.temp.cleanup()

    def record(self, name, key=None):
        key = key or self.key
        der = key.public_key().public_bytes(serialization.Encoding.DER, serialization.PublicFormat.SubjectPublicKeyInfo)
        return {"addr": hashlib.sha1(der).hexdigest(), "publickey": base64.b64encode(der).decode(), "signature": base64.b64encode(key.sign(name.encode(), padding.PKCS1v15(), hashes.SHA512())).decode()}

    def test_register_lookup_and_idempotent_retry(self):
        data = self.record("alice")
        self.assertEqual(self.directory.register("alice", data)[0], 200)
        self.assertEqual(self.directory.register("alice", data)[0], 200)
        self.assertEqual(self.directory.lookup("name", "alice")[1]["addr"], data["addr"])
        self.assertEqual(self.directory.lookup("addr", data["addr"])[1]["name"], "alice")

    def test_wrong_name_signature_rejected(self):
        with self.assertRaises(InvalidSignature):
            self.directory.register("mallory", self.record("alice"))

    def test_forged_address_rejected(self):
        data = self.record("alice")
        data["addr"] = "0" * 40
        with self.assertRaises(InvalidSignature):
            self.directory.register("alice", data)

    def test_no_takeover(self):
        self.directory.register("alice", self.record("alice"))
        other = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        self.assertEqual(self.directory.register("alice", self.record("alice", other))[0], 409)

    def test_one_name_per_account(self):
        self.directory.register("alice", self.record("alice"))
        self.assertEqual(self.directory.register("alice2", self.record("alice2"))[0], 409)

    def test_invalid_names_and_sql_injection(self):
        for name in ("a", "' OR 1=1 --", "a/b", "x" * 33):
            with self.assertRaises(ValueError):
                verified_record(name, self.record("alice"))
        self.assertEqual(self.directory.lookup("name", "' OR 1=1 --")[0], 400)

    def test_database_survives_reopen(self):
        self.directory.register("alice", self.record("alice"))
        reopened = Directory(self.directory.db_path)
        self.assertEqual(reopened.lookup("name", "alice")[0], 200)

    def test_wsgi_limits_and_malformed_json(self):
        for body, size, expected in ((b"{}", "20000", "413"), (b"{bad", "4", "400")):
            status = []
            self.directory({"PATH_INFO": "/name/alice", "REQUEST_METHOD": "POST", "CONTENT_LENGTH": size, "wsgi.input": io.BytesIO(body)}, lambda s, h: status.append(s))
            self.assertTrue(status[0].startswith(expected))


if __name__ == "__main__":
    unittest.main()
