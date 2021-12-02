#!/bin/sh

set -e
cd "$(dirname "$0")"/..

gawk -v part="$2" -f code/main.awk < "in/${1}${2}.txt"
