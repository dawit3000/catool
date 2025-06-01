# catool 1.0.0

Initial release of the **catool** (Compensation Analysis Tool) package.

## ✨ Features

- Calculates overload compensation based on institutional policies and enrollment thresholds
- Implements proration logic for courses with low enrollment (default: 4–9 students)
- Identifies qualified credit hours over the regular teaching load (default: 12 hours)
- Returns detailed, instructor-level summary blocks with total compensation
- Supports batch summaries across all instructors
- Allows filtering by subject, instructor, or division
- Provides readable, export-ready tibbles for reporting
- Includes a comprehensive vignette (`catool-walkthrough`) explaining methodology and examples

## 📦 Infrastructure

- Fully documented with `roxygen2` and includes runnable examples
- Tested on Windows, Ubuntu, Fedora, and macOS
- Includes unit tests (via `testthat`) and GitHub Actions for continuous integration
- Licensed under AGPL-3

