# File encryption using SOPS and age

## Create a keypair

**Note: passphrase protected keypairs do not seem to be supported for sops**

```sh
rage-keygen > keypair.txt
```

## Encrypt a file

**Note: preserve the file extension or sops won't what editor to open with**

```sh
sops --encrypt --age <AGE PUBLIC KEY> secrets.json > secrets.enc.json
```

## Edit an encrypted file

```sh
export SOPS_AGE_KEY_FILE=/full/path/to/keypair.txt
sops keypair.txt
```

