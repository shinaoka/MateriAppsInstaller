#!/bin/sh
set -e

cd ${GITHUB_WORKSPACE}/apps/$1
sh install.sh
sh runtest.sh
