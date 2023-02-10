# File encryption using SOPS and age

## Usage

### Create a keypair

```sh
rage-keygen > keypair.txt
```

### Encrypt a file

**Note: preserve the file extension or sops won't what editor to open with**

```sh
sops --encrypt --age <AGE PUBLIC KEY> secrets.json > secrets.enc.json
```

### Edit an encrypted file

```sh
export SOPS_AGE_KEY_FILE=/full/path/to/keypair.txt
sops keypair.txt
```

### Create a passphrase protected keypair

```sh
rage -p -o passphrase_keypair.txt <(rage-keygen)
```

### Encrypt using passphrase protected keypair

```sh
sops --encrypt --age $(rage --decrypt passphrase_keypair.txt | grep 'public key:' | sed 's/# public key: //g') secrets.json > secrets.enc.json
```

### Decrypt using passphrase protected keypair

```
export SOPS_AGE_KEY="$(rage -d $PWD/passphrase_keypair.txt)"
sops secrets.enc.json
```

## Notes

SOPS can also be used to encrypt parts of a file. e.g.

{"secret_key": "foo"} --> {"secret_key": "jdaklfjlsdkflka;"}
