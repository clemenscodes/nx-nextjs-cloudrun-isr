#!/bin/sh

nx format --libs-and-apps
yarn all build --parallel "$1"
yarn all lint --parallel "$1"
yarn all test --parallel "$1"
yarn all e2e --parallel 1
