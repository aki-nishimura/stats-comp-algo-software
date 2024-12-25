#!/usr/bin/env bash

# After running this script, remember also to 1) invite students to the organization
# so that they can open pull requests and 2) change the base member priviledge to "write."
# Ref:
# - https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/requesting-a-pull-request-review
# - https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/setting-base-permissions-for-an-organization

input_flag=$1
gh_orgname="stats-comp-algo-software-2025"
reponame="hiperglm"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
input_file="${SCRIPT_DIR}/github_usernames.txt"

while read line
do
	gh_usrname="$line"
	if [[ $input_flag == "update" ]]; then
		cd $gh_usrname
		git fetch --all --update-head-ok
		git push --all "https://github.com/${gh_orgname}/${gh_usrname}"
	else
		git clone --mirror "https://github.com/${gh_usrname}/${reponame}" ${gh_usrname}/.git
		cd $gh_usrname
		git config --bool core.bare false

		gh repo create --public "https://github.com/${gh_orgname}/${gh_usrname}"
		git push --all "https://github.com/${gh_orgname}/${gh_usrname}"
	fi
	cd ..
done < "$input_file"