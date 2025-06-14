## Test environments

* Windows 11, R 4.4.0  
* GitHub Actions: macOS-latest, ubuntu-latest, windows-latest  
  [https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)  
* R-hub: Windows (R 4.3.2), Ubuntu, Fedora  
* Win-builder: R-devel (2025-06-09 build)

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Package purpose

The `catool` (Compensation Analysis Tool) R package calculates overload compensation for college instructors based on institutional policies, teaching loads, and enrollment thresholds. It identifies qualified credit hours, applies proration rules where applicable, and generates formatted summary tables suitable for reporting and payroll.

The tool promotes fairness, transparency, and reproducibility, replacing fragile spreadsheet processes with a robust R-based solution.

## Vignettes and documentation

Includes a comprehensive walkthrough vignette covering compensation logic, usage examples, and flexible support for individual and batch analysis:  
📄 [https://dawit3000.github.io/catool/articles/catool-walkthrough.html](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)

## Submission notes

* This version (1.0.1) is a resubmission to address CRAN feedback from 1.0.0. The earlier version was rejected due to one non-standard top-level file (`README.html`) and an automated NOTE about a short interval since the last submission.
* The file `README.html` has now been excluded via `.Rbuildignore`.
* The short interval NOTE ("Days since last update: 4") was due to a necessary correction and is acknowledged here.
* Additional updates in this version include:
  * Cleaned and consistent output formatting for summary tables
  * All-uppercase column names across outputs
  * Optional weighted-blend logic (used only in Shiny app interface)
* All exported functions are documented and include examples.
* All console output is removed or made suppressible.
* `globalVariables()` used to eliminate visible binding notes.
* LICENSE file removed; `License: AGPL-3` declared properly in DESCRIPTION.

## Reverse dependencies

This is a new package with no reverse dependencies.
