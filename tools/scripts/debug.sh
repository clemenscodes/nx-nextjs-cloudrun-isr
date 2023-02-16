#!/bin/sh

yarn failed build  --parallel "$1"
yarn failed lint --parallel "$1"
yarn failed test --parallel "$1"
yarn failed e2e --parallel 1
