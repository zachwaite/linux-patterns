#! /usr/bin/env bash

set -o errexit
set -o nounset


# ================================== Main =============================================


export GNUPGHOME="$(mktemp -d ./pgpkeys-XXXXXX)"
gpg --no-tty --batch --gen-key ./example-pgp-key.batch
