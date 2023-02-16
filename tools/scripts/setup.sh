#!/bin/sh

set -e

npx nx deploy
npx nx deploy web
npx nx deploy web --configuration=production
