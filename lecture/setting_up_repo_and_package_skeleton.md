# Setting up a Git repo and GitHub remote for an R package

- Initialize `hiperLogit` package skeleton
  * `usethis::create_package("~/hiperLogit")`
  * Create a Github repo `hiper-logit-demo` and set it as a remote
  * `usethis::use_mit_license()`
    - Open the repo on GitKraken for visual diff
    - Permissive vs. copyleft
    - Personal view: Use MIT license as as a default, Apache if your employer asks for it, and GPL if you have to
  * Edit DESCRIPTION
    - "Title: High-performance logistic regression for large data sets"
    - Set author and creator (more details on these roles [here](https://journal.r-project.org/archive/2012/RJ-2012-009/RJ-2012-009.pdf))
    - "Description: TBA"
- Top-down programming: start with a high-level overview of what the program does and then recursively break it down into sub-routines
- Outline function signatures:
  * `R/hiper_logit.R`
  * `hiper_logit <- function() {...}`
    - What input args should the function take?
    - Input `outcome` and `design` (specifically in this order; we'll change this later)
    - Warn that the function is yet to be implemented
    - Make a todo note to implement model fitting
    - Return an empty list: `hlogit_out <- list()`
  * `model_output.R`
    - No need to write a feature-rich package right from the beginning, but what are the min required outputs for this package to be a valuable resource for statistical analysis?
    - `coef()`, `vcov()`, (and `print()`)
    - `warning("This function is yet to be implemented.")` & `cat("`hiper_logit` output\n")`
- Now install the package via `R CMD build/install` and try calling `hiper_logit()`
- Oops, I forgot to export functions...
  * `#' @export`
  * Roxygenize
- Oops, I overwrote `base::print()`...
  * Turn the output into an S3 object: `class(hlogit_out) <- "hlogit"`
  * Add `.hlogit` to the model output functions
  * (After forgetting to do so,) Roxygenize again
- Decide, out of whim, to change the package name from `hiperLogit` to `hiperglm`
  * Gotta replace all the "logit" word from the repo: `git grep --ignore-case logit`
  * Rename variables with `find R -type f -name "*.R" -exec gsed -i 's/logit/glm/g' {} \;` (since RStudio currently doesn't support refactoring) and `gsed -i 's/Logit/_glm/g' DESCRIPTION LICENSE LICENSE.md .Rbuildignore`
  * Also need to change all the file names: `find * -iname "*logit*"`
  * Add a check for supported models now that the package name is more general
  * Rename git repo
  * Change remote url `git remote set-url origin ...`
- Git branch and merge (conflict)
  * Create a `feature-A` branch and "implement it" just as a comment `# Here is feature A` for illustration purpose
  * Similarly "implement" feature B in the `main` branch in a non-overlapping location 
  <!--- not too close to the function signature to avoid a conflict during the later `cherry-pick` --->
  * Merge the `feature-A` branch
    - Delete it after merge to keep thing clean
    - Visualize the effect with Git GUI
    - `git reflog` to show how even accidental deleting a branch and other destructive operations can be undone
  * Make and check out a `func-signature` branch, swap the order of `outcome` and `design` there
  * Change `hiper_glm()` to `hyper_glm()` back in the `main` branch
  * Merge `func-signature` after resolving the merge conflict
- Clean up the parts added just for git merge demo
  * `git reset` (without the `--hard` option)
  * `git stash`; illustrate `git stash pop`
  * `git cherry-pick` the swapping of `outcome` and `design`
- Clean up the git history via `git rebase -i` before pushing
  * Is the record of this change of some value to others and my future self?

# Reading assignments
* Licensing: permissive vs. copyleft
  - Choosing among three representative licenses: https://www.exygy.com/blog/which-license-should-i-use-mit-vs-apache-vs-gpl
  - Perspective on the current trend toward more permissive licensing: https://www.r-bloggers.com/2020/04/why-dash-uses-the-mit-license-and-not-a-copyleft-gpl-license/
* R package basics:
  - Short but clear tutorial by Hilary Parker: https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
  - "Minimal" (but longer than Hilary's) tutorial by Karl Broman: https://kbroman.org/pkg_primer/
* S3 object: https://adv-r.hadley.nz/s3.html

<!--- Useful reference 
https://github.com/aki-nishimura/hiperglm/tree/pkg-skeleton
--->

<!--- Useful code snippets
n_obs <- 32; n_pred <- 4
X <- matrix(rnorm(n_obs * n_pred), nrow = n_obs)
beta <- rnorm(n_pred)
y <- X %*% beta + rnorm(n_obs)
--->
