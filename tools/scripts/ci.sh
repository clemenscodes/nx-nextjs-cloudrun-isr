#!/bin/sh

nx format --libs-and-apps &&
yarn affected build --nx-bail --parallel "$1" &&
yarn affected lint --nx-bail --parallel "$1" &&
yarn affected test --nx-bail  --parallel "$1" &&
yarn affected e2e --parallel 1
