
# catool: Compensation Analysis Tool

[![GitHub
version](https://img.shields.io/github/v/tag/dawit3000/catool?label=GitHub&logo=github)](https://github.com/dawit3000/catool)
[![R-CMD-check](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

**catool** (Compensation Analysis Tool) is an R package for calculating
fair and transparent overload pay for college instructors. It processes
course schedules to identify overload credit hours and computes prorated
compensation based on institutional policy, enrollment thresholds, and
pay rates.

------------------------------------------------------------------------

## 🔧 Features

- Filters qualified credit hours by enrollment and subject
- Computes prorated overload compensation per course
- Summarizes total pay per instructor
- Allows full-schedule batch analysis
- Includes flexible filters for subject, division, and instructor
- Export-ready output for reports or payroll

------------------------------------------------------------------------

## 📦 Installation

``` r
# Install directly from GitHub
# install.packages("remotes")  # If not already installed
remotes::install_github("dawit3000/catool")
```

------------------------------------------------------------------------

## 🗂️ Sample Usage

``` r
library(catool)
```

### Load schedule data

``` r
schedule <- read.csv("data-raw/schedule.csv")
```

### Overload compensation for one instructor

``` r
IS <- get_instructor_schedule("Lalau-Hitchcock, Diksha", schedule)
ol_comp(IS)
```

### Apply a custom institutional policy

``` r
ol_comp(IS, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12)
```

### Full-schedule compensation summary

``` r
ol_comp_summary(schedule)
```

------------------------------------------------------------------------

## 🔍 Advanced Filtering

``` r
# Filter by division
get_division_schedule("Business Administration", schedule)

# Filter by subject code pattern (regex)
get_subject_schedule("^MATH|^STAT", schedule)

# Combine filters
filter_schedule(schedule, division = "Nursing", instructor_pattern = "lee")
```

------------------------------------------------------------------------

## 📄 Input Requirements

A data frame with these required columns:

- `INSTRUCTOR`: Instructor name
- `HRS`: Credit hours per course
- `ENRLD`: Student enrollment
- `SUBJ`: Subject code (for advanced filtering)

------------------------------------------------------------------------

## 📊 Output

The result is a tidy tibble that includes:

- Overload Pay by Course
- Total Compensation (USD)
- Summary notes
- Course-level and instructor-level breakdowns

------------------------------------------------------------------------

## ✍️ Author

Developed and maintained by **Dawit Aberra**.

See the
[Walkthrough](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)
for full details and methodology.
