
# OVERLOAD COMPENSATION ANALYSIS TOOL (OverloadCompTool)

[![GitHub
version](https://img.shields.io/github/v/tag/dawit3000/OverloadCompTool?label=GitHub&logo=github)](https://github.com/dawit3000/OverloadCompTool)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

Tool for analyzing faculty overload compensation…

The **Overload Compensation Analysis Tool** is an R package designed to
calculate fair and transparent overload pay for college instructors. It
works from a course schedule to identify credit hour overloads and
compute prorated pay based on enrollment thresholds.

## 🔧 Features

- Automatically filters for qualified courses
- Calculates prorated overload pay
- Summarizes compensation per instructor
- Supports full-schedule batch summaries
- Output-ready for Excel or PDF formats

## 📦 Installation

``` r
# Install directly from GitHub
# install.packages("remotes")
remotes::install_github("yourusername/OverloadCompTool")
```

## 📁 Sample Usage

``` r
library(OverloadCompTool)

# Load your schedule data
schedule <- read.csv("Schedule.csv")

# Get one instructor's pay
IS <- get_instructor_schedule("Smith, Jane", schedule)
calculate_overload_compensation(IS)

# Summarize everyone
summarize_all_instructors(schedule)
```

## 📄 Inputs

- A data frame with at least these columns:

  - `INSTRUCTOR`
  - `HRS` (Credit Hours)
  - `ENRLD` (Enrollment)

## 📊 Output

A tidy data frame including:

- Overload Pay by Course
- Total Compensation (USD)
- Summary notes

## ✍️ Author

Developed by Dawit Aberra. See `vignette("overload-comp-tool")` for a
full walkthrough.
