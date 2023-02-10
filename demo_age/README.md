# age protocol

The age protocol is for file encryption. The reference implementation is in go
[github](https://github.com/FiloSottile/age), but there is a compatible rust
implementation [github](https://github.com/str4d/rage). The go implementation is
more ubiquitous, but as long as the rust implementation remains compatible, I
would prefer that because I could more easily build it from source offline if
needed. Offline first is an important consideration for security for me.

## Installation

```sh
cargo install rage
```

## Create a passphrase encrypted file

This is the most basic use case - password protect a file.

```sh
rage -p -o passphrase_protected.json secrets.json
```

## Decyrpt a passphrase encrypted file

```sh
rage --decrypt passphrase_protected.json
```

## Create a keypair

A keypair is a single file in age. The public key is commented out in the
keyfile and also printed to the screen when generating for easily copying. This
makes it easy to generate keys. Ease of keygen is actually favorable for
security. The keys are also quit short relative to e.g. ssh rsa keys or pgp
keys.

```sh
rage-keygen > plain_keypair.txt
```

## Encrypt a file

```sh
rage -o secrets.enc.json -r <AGE PUBLIC KEY> secrets.json
```

## Decrypt a file

```sh
rage --decrypt -i plain_keypair.txt secrets.enc.json
```

## Create a passphrase protected keypair

```sh
rage -p -o passphrase_keypair.json <(rage-keygen)
```

## Encrypt a file using passphrase protected keypair

```sh
rage -o secrets.enc.json -r $(rage --decrypt passphrase_keypair.txt | grep 'public key:' | sed 's/# public key: //g') secrets.json
```

## Decrypt a file using passphrase protected keypair

rage will automatically prompt for passphrase when decrypting

```sh
rage --decrypt -i passphrase_keypair.txt secrets.enc.json
```
