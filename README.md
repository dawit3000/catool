
# COAT: Compensation Analysis Tool

[![GitHub
version](https://img.shields.io/github/v/tag/dawit3000/coat?label=GitHub&logo=github)](https://github.com/dawit3000/coat)
[![R-CMD-check](https://github.com/dawit3000/coat/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dawit3000/coat/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

**COAT** (Compensation Analysis Tool) is an R package for calculating
fair and transparent overload pay for college instructors. It uses
course schedule data to identify credit hour overloads and computes
prorated compensation based on enrollment thresholds and pay rates.

------------------------------------------------------------------------

## 🔧 Features

- Filters qualified credit hours based on institutional policies
- Computes prorated overload pay per course
- Summarizes total compensation per instructor
- Supports full-schedule batch summaries
- Output-ready for Excel, PDF, or reporting

------------------------------------------------------------------------

## 📦 Installation

``` r
# Install directly from GitHub
# install.packages("remotes")  # Run once if not already installed
remotes::install_github("dawit3000/coat")
```

------------------------------------------------------------------------

## 📁 Sample Usage

``` r
library(coat)
```

### Load schedule data

``` r
schedule <- read.csv("data-raw/schedule.csv")
```

### Overload compensation for one instructor (default policy)

``` r
IS <- get_instructor_schedule("Lalau-Hitchcock, Diksha", schedule)
ol_comp(IS)
```

### Apply a custom institutional policy

- Overload pay begins after 12 credit hours (`reg_load = 12`)
- Prorated pay for 4–9 students (inclusive)
- No compensation if `ENRLD < 4`
- Full pay if `ENRLD ≥ 10`
- Rate per credit hour: `2500 / 3`

``` r
IS <- get_instructor_schedule("Lalau-Hitchcock, Diksha", schedule)
ol_comp(IS, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12)
```

### Compensation summary for all instructors

``` r
ol_comp_summary(schedule)
ol_comp_summary(schedule, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12)
```

------------------------------------------------------------------------

## 📄 Input Requirements

A data frame with at least the following columns:

- `INSTRUCTOR`: Instructor name
- `HRS`: Course credit hours
- `ENRLD`: Student enrollment

------------------------------------------------------------------------

## 📊 Output

A tidy tibble that includes:

- Overload Pay by Course
- Total Compensation (USD)
- Summary notes

The last few rows summarize qualified credit hours and total overload
pay.

------------------------------------------------------------------------

## ✍️ Author

Developed and maintained by Dawit Aberra.

See the
[vignette](https://dawit3000.github.io/coat/coat-walkthrough.html) for a
full walkthrough.


    ---

    Let me know if you want the vignette link replaced with a local `doc/` path instead of GitHub Pages.
