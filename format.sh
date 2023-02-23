#!/bin/bash
set -ex

cd $(dirname $0)
swiftformat . --swiftversion 5.7.2 --indent 2 --maxwidth 80
