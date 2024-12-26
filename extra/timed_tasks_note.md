# Before the term starts
* Turn public repos from previous year to private 
* Start a new course repo for the current year
* Update the links to the course repo by running `update_academic_year.sh`

# Final project
Make appropriate parts of the `hiperglm` repo public:
```
git push public logit-model-eigen-cleaned
git checkout master
git reset --hard general-model-dev-ready
git push public 
```