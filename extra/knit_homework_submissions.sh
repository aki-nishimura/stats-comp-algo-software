#!/usr/bin/env bash
# Example usage: bash extra/knit_hw_submissions.sh hw1

hw_branch_name=$1

mkdir -p "homework/${hw_branch_name}"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
input_file="${SCRIPT_DIR}/github_usernames.txt"

while read line
do
	gh_usrname="$line"

	if ! grep -q ${gh_usrname} <(git remote -v); then
		# Add a remote only if it doesn't yet exist 
		git remote add ${gh_usrname} "https://github.com/${gh_usrname}/stats-comp-algo-software-2025"
	fi
		
	echo "Fetching and checking out ${gh_usrname}'s submission of ${hw_branch_name}..."
	git fetch ${gh_usrname} ${hw_branch_name} 2> /dev/null
	git checkout "${gh_usrname}/${hw_branch_name}" -- "homework/${hw_branch_name}.Rmd" 2> /dev/null
	if [ $? -eq 0 ]; then
		echo -n "Knitting the Rmd file... "
		Rscript -e \
			"rmarkdown::render('homework/${hw_branch_name}.Rmd', output_format = 'html_document', quiet = TRUE)"
		mv "homework/${hw_branch_name}.html" "homework/${hw_branch_name}/${gh_usrname}.html"
		echo "done."
	else
		echo "Branch or Rmd file not found."
	fi

done < "$input_file"