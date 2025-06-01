
# catool: Compensation Analysis Tool

[![CRAN
status](https://www.r-pkg.org/badges/version/catool)](https://CRAN.R-project.org/package=catool)
[![R-CMD-check](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![GitHub
version](https://img.shields.io/github/v/tag/dawit3000/catool?label=GitHub&logo=github)](https://github.com/dawit3000/catool)

**catool** (Compensation Analysis Tool) is an R package that calculates
fair and transparent overload pay for college instructors. It processes
course schedule data, identifies credit hour overloads, and applies
proration rules to compute compensation based on institutional policies.

Unlike simple per-course systems, **catool** prorates pay based on
**qualified credit hours** only — and only when enrollment thresholds
are not met.

------------------------------------------------------------------------

## 🔧 Features

- Filters out courses ineligible for compensation (e.g., under-enrolled)
- Identifies overload based on regular teaching load
- Computes pay per **qualified credit hour**, prorated where applicable
- Prioritizes assigning higher-enrollment courses to regular load
- Summarizes compensation by instructor and across full schedules
- Supports flexible filtering by subject, instructor, or division
- Returns export-ready, human-readable tibble output

------------------------------------------------------------------------

## 📦 Installation

``` r
# Install from GitHub
# install.packages("remotes")  # If needed
remotes::install_github("dawit3000/catool")
```

------------------------------------------------------------------------

## 🗂️ Example Usage

``` r
library(catool)
schedule <- read.csv("data-raw/schedule.csv")

# Analyze one instructor
ol_comp(get_instructor_schedule("Lalau-Hitchcock", schedule))

# With a custom institutional policy
ol_comp(get_instructor_schedule("Smith", schedule),
        L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12)

# Summarize compensation across the full schedule
ol_comp_summary(schedule)
```

------------------------------------------------------------------------

## 🔍 Advanced Filtering

``` r
# Filter by division
get_division_schedule("Business Administration", schedule)

# Filter by subject codes using regex
get_subject_schedule("^MATH|^STAT", schedule)

# Apply combined filters
filter_schedule(schedule,
                division = "Nursing",
                instructor_pattern = "lee")
```

------------------------------------------------------------------------

## 📄 Input Format

Your input schedule must include the following columns:

| Column       | Description                     |
|--------------|---------------------------------|
| `INSTRUCTOR` | Instructor’s name               |
| `HRS`        | Credit hours per course         |
| `ENRLD`      | Enrollment in the course        |
| `SUBJ`       | Subject code (e.g., MATH, ENGL) |

Additional columns like `TITLE`, `DAYS`, or `LOCATION` are allowed but
not required.

------------------------------------------------------------------------

## 📊 Output Overview

The output is a tidy tibble with:

- `QUALIFIED_CR`: Credit hours eligible for overload pay
- `ROW_AMOUNT`: Compensation amount for those hours
- `TYPE`: `"PRORATED"` where enrollment is below threshold; blank
  otherwise
- A summary block showing total compensation, rate used, and policy
  notes
- `SUMMARY`: A final column providing labeled context (e.g.,
  “INSTRUCTOR: Smith”)

Pay is calculated *only* on qualified credit hours **beyond regular
teaching load**. When enrollment for those hours is below 10, pay is
prorated accordingly — not per course.

------------------------------------------------------------------------

## 📚 Documentation

📖 [**Full Walkthrough
Vignette**](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)

Includes policy logic, assumptions, and examples for individual and
batch analyses.

------------------------------------------------------------------------

## ✍️ Author

Developed and maintained by **Dawit Aberra** 📧 <dawit3000@hotmail.com>
Licensed under **AGPL-3**

Please cite appropriately when using this tool in research, audits, or
policy design. For issues or suggestions, open a [GitHub
issue](https://github.com/dawit3000/catool/issues).
