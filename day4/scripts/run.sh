#!/bin/sh

set -e
cd "$(dirname "$0")"/..

racket code/main.rkt "${2}" < "in/${1}${2}.txt"
