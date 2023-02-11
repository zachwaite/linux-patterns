# SOPS - 2023-02-10

## tldr;

[sops](https://github.com/mozilla/sops) is an encrypted file editing tool. It is
useful for storing secrets in git repositories, e.g. config files with api keys.
This allows you to store your full config in git and facilitates automated and
reproducible builds. It integrates with your favorite text editor, can leverage
different encryption key tools and can be used on Linux, Mac and Windows.

## Example

This is an example using [age](https://github.com/FiloSottile/age) for
encryption.

Create an age keypair

```bash
age-keygen > keypair.txt
# Public key: age1mn7m4qf5d3dphyrs7gv7nsp637srctkkdsypwx7r83cg7lfa445sgh5jx2
```

Encrypt a file with secrets

```bash
export AGE_PUBLIC_KEY=age1mn7m4qf5d3dphyrs7gv7nsp637srctkkdsypwx7r83cg7lfa445sgh5jx2
sops --encrypt --age $AGE_PUBLIC_KEY secrets.json > secrets.enc.json
```

Edit a file with secrets

```bash
export SOPS_AGE_KEY_FILE=$PWD/keypair.txt
sops secrets.enc.json
```

## Links

- [Zach's sops demo_repo](https://github.com/zachwaite/linux-patterns/tree/main/demo_sops)
- [Zach's age demo repo](https://github.com/zachwaite/linux-patterns/tree/main/demo_age)
- [sops](https://github.com/mozilla/sops)
- [age](https://github.com/FiloSottile/age)
- [rage](https://github.com/str4d/rage)
