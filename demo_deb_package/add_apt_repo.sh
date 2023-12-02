#! /usr/bin/env bash

set -o errexit
set -o nounset


# ================================== Main =============================================


echo "deb [arch=amd64 signed-by=/home/zach/VimProjects/patterns/linux-patterns/demo_deb_package/pgp-key.public] http://127.0.0.1:8000/apt-repo stable main" | sudo tee /etc/apt/sources.list.d/example.list
