#! /usr/bin/env bash

set -o errexit
set -o nounset

greet() {
  local name="${1:-World}";
  echo "Hello $name";
}


# ================================== Main =============================================

echo "Using default arg: --> $(greet)"
echo "Supplied arg: --> $(greet Zach)"
