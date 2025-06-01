# catool 1.0.0

Initial release of the **catool** (Compensation Analysis Tool) R package.

## ✨ Features

- Calculates overload compensation based on institutional policies and enrollment thresholds
- Applies proration logic for courses with low enrollment (default: 4–9 students)
- Identifies qualified credit hours exceeding the regular teaching load (default: 12 hours)
- Returns detailed, instructor-level summaries with total compensation
- Supports batch summaries across all instructors
- Offers flexible filtering by subject, instructor, department, or division
- Produces tidy, export-ready tibbles for audits and administrative reporting
- Includes a full walkthrough vignette (`catool-walkthrough`) explaining policy logic and usage examples

## 📦 Infrastructure

- Fully documented with `roxygen2`; all exported functions include runnable examples
- Tested on Windows, Ubuntu, Fedora, and macOS platforms
- Unit tests included (via `testthat`)
- GitHub Actions CI setup for multi-platform testing
- Licensed under AGPL-3
