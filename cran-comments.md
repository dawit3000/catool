## Test environments
* Windows 11, R 4.4.0  
* GitHub Actions: [macOS-latest, ubuntu-latest, windows-latest](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)  
* R-hub: Windows, Ubuntu, Fedora (R 4.3.2)

## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Package purpose
The `catool` (Compensation Analysis Tool) R package calculates overload compensation for college instructors using institutional policies, teaching loads, and enrollment-based thresholds. It identifies qualified credit hours, applies proration logic when needed, and generates spreadsheet-ready summary tables. The tool supports fairness and transparency while reducing manual administrative errors.

## Vignettes and Documentation
Includes a walkthrough vignette covering policy logic, usage examples, proration rules, and full-schedule vs. individual analysis:  
📄 [catool-walkthrough](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)

## Submission notes
This is the initial CRAN submission of the `catool` package.  
All exported functions are documented and include usage examples.  
Continuous integration via GitHub Actions ensures platform-wide checks.  
A comprehensive README and vignette are included.

## Reverse dependencies
This is a new package with no reverse dependencies.
