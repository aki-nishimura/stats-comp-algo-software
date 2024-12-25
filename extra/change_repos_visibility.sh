#!/usr/bin/env bash

gh_orgname="stats-comp-algo-software-2024"
reponame="hiperglm"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
input_file="${SCRIPT_DIR}/github_usernames.txt"

while read line
do
	gh_usrname="$line"
	gh repo edit "https://github.com/${gh_orgname}/${gh_usrname}" --visibility private
done < "$input_file"