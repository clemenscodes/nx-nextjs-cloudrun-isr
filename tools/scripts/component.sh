#!/bin/sh

component="$1"

nx generate @nrwl/next:component "$component" --directory=components --project=shared --export -s=css

nx generate @nrwl/react:component-story --componentPath=components/"$component"/"$component".tsx --project=shared

nx format
