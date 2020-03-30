#!/usr/bin/env python3

from Crypto.Hash import SHA, SHA256
from Crypto.Signature import PKCS1_v1_5
from Crypto.PublicKey import RSA
from shutil import copyfile
import json
import codecs



def gen_keys():
    privKey = RSA.generate(1024)
    publKey = privKey.publickey().exportKey('PEM')

    f = open("/var/www/onlyoffice/license_key.pub", "w+")
    f.write(publKey.decode('utf-8'))
    f.close()

    return publKey, privKey



def write_license(publKey, privKey):
    license = {
        "branding": False,
        "connections": 9999,
        "customization": False,
        "end_date": "2099-01-01T23:59:59.000Z",
        "light": "False",
        "mode": "",
        "portal_count": "0",
        "process": 2,
        "ssbranding": False,
        "test": "False",
        "trial": "False",
        "user_quota": "0",
        "users_count": 9999,
        "users_expire": 99999,
        "whiteLabel": False,
        "customer_id": "customerID",
        "start_date": "2020-01-01T00:00:00.000Z",
        "users": [],
        "version": 2
    }

    jsonData = codecs.encode(json.dumps(license, separators=(',', ':')), encoding='utf-8')

    digest = SHA.new(jsonData)
    signer = PKCS1_v1_5.new(privKey)
    signature = signer.sign(digest)
    finalSignature = signature.hex()

    license['signature'] = finalSignature

    f = open("/var/www/onlyoffice/license.lic", "w+")
    f.write(json.dumps(license))
    f.close



def patch_files():
    basePath = "/var/www/onlyoffice/documentserver/server/"
    files = ["DocService/docservice", "FileConverter/converter"]

    for file in files:
        f = open(basePath + file, 'rb')
        data = f.read()
        f.close()

        replacedData = data.replace(b"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRhGF7X4A0ZVlEg594WmODVVUI\niiPQs04aLmvfg8SborHss5gQXu0aIdUT6nb5rTh5hD2yfpF2WIW6M8z0WxRhwicg\nXwi80H1aLPf6lEPPLvN29EhQNjBpkFkAJUbS8uuhJEeKw0cE49g80eBBF4BCqSL6\nPFQbP9/rByxdxEoAIQIDAQAB\n-----END PUBLIC KEY-----", bytes(publKey))

        f = open(basePath + file, 'wb')
        f.write(replacedData)
        f.close()




print("Generating and exporting key pair...")
publKey, privKey = gen_keys()

print("Writing license file...")
write_license(publKey, privKey)

print("Patching document server and converter...")
patch_files()
