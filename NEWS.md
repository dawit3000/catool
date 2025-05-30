# coat 1.0.0

## First Stable Release 🎉

🚀 **coat** (Compensation Analysis Tool) is a fully-featured R package for analyzing faculty overload compensation with transparency, consistency, and proration logic based on enrollment thresholds.

### ✅ Major Updates

#### 🆕 Function Renames for Clarity & Consistency
- `calculate_overload_compensation()` → `ol_comp()`
- `summarize_instructor_by_index()` → `ol_comp_byindex()`
- `summarize_all_instructors()` → `ol_comp_summary()`
- `list_unique_instructors()` → `get_unique_instructors()`

#### 📦 Core Features
- `ol_comp()`:
  - Calculates prorated overload pay per course.
  - Applies institutional rules (e.g., enrollment thresholds and regular load).
  
- `get_instructor_schedule()`:
  - Extracts one instructor’s schedule from a full course dataset.

- `ol_comp_byindex()` and `ol_comp_summary()`:
  - Generate readable summaries by instructor or across the full schedule.

- `get_unique_instructors()`:
  - Returns alphabetically sorted list of instructors.

### 📊 Data
- `schedule`: Sample dataset for testing with variables `HRS`, `ENRLD`, and `INSTRUCTOR`.

### 🔧 Internal Improvements
- Standardized roxygen documentation for all exported functions
- Updated README, vignette, tests, and DESCRIPTION
- Cleaned global variable declarations to satisfy CRAN checks
- Passed `R CMD check` with: **0 errors | 0 warnings | 3 notes**  
  (all notes are documented in `cran-comments.md`)

---

💡 For a full walkthrough, see the [package vignette](https://dawit3000.github.io/coat/articles/coat-walkthrough.html).

