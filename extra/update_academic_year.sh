#!/usr/bin/env bash

if [ -z "$1" ]; then
	curr_year=$(date +%Y)
else
	curr_year="$1"
fi
prev_year=$(($curr_year - 1))
find . -type f \( -name "*.Rmd" -o -name "*.sh" \) -exec \
	gsed -i "s/stats-comp-algo-software-${prev_year}/stats-comp-algo-software-${curr_year}/g" {} \;