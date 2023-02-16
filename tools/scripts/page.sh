#!/bin/sh

page="$1"

nx generate @nrwl/next:component "$page" --directory=pages --project=shared --export -s=css

nx generate @nrwl/react:component-story --componentPath=pages/"$page"/"$page".tsx --project=shared

nx format
