# age protocol

age protocol is for file encryption. The reference implementation is in go, but there is
a compatible rust implementation. The go implementation is more ubiquitous, but as long
as the rust implementation remains compatible, I would prefer that because I could more
easily build it from source offline if needed. Offline first is an important consideration
for security.

## Installation

```sh
cargo install rage
```

## Create a keypair

A keypair is a single file in age. The public key is commented out in the keyfile and
also printed to the screen when generating for easily copying. This makes it easy to
generate keys. Ease of keygen is actually favorable for security.

```sh
rage-keygen > kepair.txt
```

## Create a passphrase encrypted keypair

```sh
rage -p -o passphrase_keypair.txt <(rage-keygen)
```

## Encrypt a file

```sh
rage -o secrets.json.age -r <AGE PUBLIC KEY> secrets.json
```

## Decrypt a file

```sh
rage --decrypt -i keypair.txt secrets.json.age
```

