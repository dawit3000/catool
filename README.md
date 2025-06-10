
# catool: Compensation Analysis Tool

[![CRAN
status](https://www.r-pkg.org/badges/version/catool)](https://CRAN.R-project.org/package=catool)
[![R-CMD-check](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dawit3000/catool/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![GitHub
version](https://img.shields.io/github/v/tag/dawit3000/catool?label=GitHub&logo=github)](https://github.com/dawit3000/catool/releases)
[![Walkthrough
Vignette](https://img.shields.io/badge/docs-walkthrough-blue)](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)

**catool** (Compensation Analysis Tool) is an R package that calculates
fair and transparent overload pay for college instructors. It analyzes
course schedules and applies institutional policy rules to determine
qualified credit hours and compensation—prorated when needed.

## 🔧 Key Features

- Filters out under-enrolled or ineligible courses
- Calculates overload based on **qualified credit hours** only
- Prorates pay for enrollments below a specified threshold
- Sorts courses by enrollment and counts from lowest up
- Supports instructor- or institution-favoring strategies
- Produces clear summary tables for individual or full-schedule use
- Tidy tibble output, ready for export and reporting

------------------------------------------------------------------------

## 🛆 Installation

``` r
# Install from GitHub
# install.packages("remotes")
remotes::install_github("dawit3000/catool")
```

------------------------------------------------------------------------

## 🗂️ Input Format

Your course schedule data must include:

| Column       | Description                          |
|--------------|--------------------------------------|
| `INSTRUCTOR` | Instructor’s name (e.g., “Smith, C”) |
| `ENRLD`      | Enrollment in each course            |
| `HRS`        | Credit hours assigned per course     |

Optional: `SUBJ`, `DEPARTMENT`, `COLLEGE`, and `PROGRAM` for advanced
filtering.

------------------------------------------------------------------------

📂 **Sample input**: The
[`schedule.csv`](https://raw.githubusercontent.com/dawit3000/catool/master/inst/extdata/schedule.csv)
file provides a realistic example of course schedule data used by the
package. It includes columns such as `SUBJ`, `CRN`, `INSTRUCTOR`,
`DEPARTMENT`, and `COLLEGE`.

------------------------------------------------------------------------

## 🧪 Quick Start

``` r
library(catool)

schedule <- data.frame(
  INSTRUCTOR = c("al-Abdul", "baxter", "Smith, Courtney"),
  ENRLD = c(12, 7, 4),
  HRS = c(3, 3, 3)
)

# Analyze one instructor
ol_comp(get_instructor_schedule("baxter", schedule))

# Apply one instructor with a custom policy
ol_comp(get_instructor_schedule("Smith", schedule),
        L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12)

# Summarize full schedule (payroll-ready summary of all instructors)
ol_comp_summary(schedule)
```

------------------------------------------------------------------------

## 🔍 Filtering Options

``` r
# Filter by subject
filter_schedule(schedule, subject_pattern = "MATH|STAT")
filter_schedule(schedule, subject_pattern = "^MATH|^STAT") # Prefix match

# Filter by department
filter_schedule(schedule, department_pattern = "Business")

# Filter by instructor
get_instructor_schedule("davis", schedule)

# List all instructors
get_unique_instructors(schedule)
```

------------------------------------------------------------------------

## 📊 Output Structure

The `ol_comp_summary()` function returns a clean tibble with:

- `QHRS`: Qualified credit hours above regular load, eligible for pay
- `PAY`: Calculated compensation per row
- `TYPE`: `"PRO"` where ENRLD \< 10, blank otherwise
- `SUMMARY`: Instructor headers, notes, and totals

**Note:** Pay is **never per-course**—only on qualified credit hours.

------------------------------------------------------------------------

## ⚖️ Policy Logic

Default institutional policy:

1.  Regular teaching load = 12 credit hours

2.  Courses with `ENRLD < 4` are excluded

3.  Qualified credit hours beyond regular load are paid at `$2,500 / 3`
    per hour

4.  For `ENRLD < 10`, pay is prorated:

    $$
    \text{Compensation} = \left(\frac{\text{ENRLD}}{10}\right) \times \text{rate per CR} \times \text{qualified CR}
    $$

5.  Overload hours are counted starting with the **least-enrolled
    eligible courses**

------------------------------------------------------------------------

## 🤮 Instructor vs Institutional Interest Inclination Strategy

You can specify how regular teaching load is assigned when determining
overload pay:

- **`favor_institution = TRUE`** → *Favor institutional interest* →
  Assign **high-enrollment courses** to regular load first → Leaves
  **low-enrollment courses** for compensation → Results in **less total
  pay**

- **`favor_institution = FALSE`** → *Favor instructor interest* → Assign
  **low-enrollment courses** to regular load first → Leaves
  **high-enrollment courses** for compensation → Results in **more total
  pay**

This option is supported in both `ol_comp()` and `ol_comp_summary()`
functions.

------------------------------------------------------------------------

## 📖 Full Walkthrough

🔗 [Vignette &
Examples](https://dawit3000.github.io/catool/articles/catool-walkthrough.html)
