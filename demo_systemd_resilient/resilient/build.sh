#! /usr/bin/env bash
# set -o errexit
set -o nounset

read -r -d '' USAGE <<- EOM
build "resilient" service

Args:
  None

Exit codes:
  0 = ok
EOM

# ================================== Main =============================================
echo "Clean up old artifacts"
rm -rf "$PWD/buildenv"
rm -rf "$PWD/build"
rm -rf "$PWD/dist"
rm -f resilient-app.1

echo "Prepare virtualenv using Python 3.10"
python3.10 -m virtualenv buildenv
PY="$PWD/buildenv/bin/python"
$PY -m pip install --upgrade pip

echo "Install resilient package from source"
$PY -m pip install .

echo "Install PyInstaller"
$PY -m pip install pyinstaller

echo "Build exe"
$PY -m PyInstaller resilient-app.py
DIST="$PWD/dist/resilient-app/"

echo "Build man pages"
pandoc resilient-app.1.md -s -t man > resilient-app.1

echo "Build deb package"
debuild --no-tgz-check -uc -us
debuild -T clean

