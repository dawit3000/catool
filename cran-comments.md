## Test environments

* Windows 11, R 4.4.0
* GitHub Actions: [macOS-latest, ubuntu-latest, windows-latest](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)
* R-hub: Windows, Ubuntu, Fedora (R 4.3.2)

## R CMD check results

✔ 0 errors | ✔ 0 warnings | ✖ 3 notes

### Notes:

* The `LICENSE` file follows the standard AGPL-3 format and is correctly declared in the `DESCRIPTION`.
* Global variable bindings (`COLLEGE`, `DEPARTMENT`, `PROGRAM`) are used in tidyverse-style NSE expressions. These are acceptable or can be suppressed via `utils::globalVariables()`.
* The timestamp note (`unable to verify current time`) is benign and does not affect package functionality.

## Package purpose

The `catool` (Compensation Analysis Tool) R package calculates overload compensation for college instructors based on institutional policies, teaching loads, and enrollment thresholds. It identifies qualified credit hours, applies proration when applicable, and generates spreadsheet-ready summary tables. The package supports transparency, fairness, and audit-readiness while reducing manual administrative errors.

## Vignettes and documentation

Includes a comprehensive walkthrough vignette detailing policy logic, function usage, proration rules, and output structure:
📄 [catool-walkthrough](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)

## Submission notes

This is the first submission of the `catool` package to CRAN.
All exported functions are documented and include runnable examples.
Continuous integration is set up via GitHub Actions.
README and vignette provide full reproducibility.

## Reverse dependencies

This is a new package with no reverse dependencies.
