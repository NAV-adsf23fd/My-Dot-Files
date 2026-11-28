#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "${BASH_SOURCE}")")"

if [ ! -e "profiles.ini" ]; then
    cp profiles.ini.example profiles.ini
fi
