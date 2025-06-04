## Test environments
* Windows 11, R 4.4.0  
* GitHub Actions: macOS-latest, ubuntu-latest, windows-latest  
  https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml  
* R-hub: Windows (R 4.3.2), Ubuntu, Fedora

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Package purpose
The `catool` (Compensation Analysis Tool) R package calculates overload compensation for college instructors based on institutional policies, regular teaching loads, and enrollment thresholds. It identifies qualified credit hours, applies proration logic when applicable, and generates spreadsheet-ready summary tables. The tool promotes fairness, transparency, and consistency while reducing manual administrative effort.

## Vignettes and documentation
Includes a walkthrough vignette explaining policy logic, usage examples, compensation rules, and both full-schedule and individual analysis.  
📄 https://dawit3000.github.io/catool/articles/catool-walkthrough.html

## Submission notes
This is the initial CRAN submission of the `catool` package.  
* All exported functions are documented and include usage examples.  
* Console messages have been removed or made suppressible (per CRAN policy).  
* Global variable warnings (e.g., `COLLEGE`, `DEPARTMENT`) resolved via `globalVariables()`.  
* The `LICENSE` file has been removed, and the `DESCRIPTION` now correctly declares only `AGPL-3`.

## Reverse dependencies
This is a new package with no reverse dependencies.
