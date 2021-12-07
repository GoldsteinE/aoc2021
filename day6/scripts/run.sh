#!/bin/sh

set -e
cd "$(dirname "$0")"/..

python code/runner.py code/main.pyasm "in/${1}${2}.txt" "${2}"
