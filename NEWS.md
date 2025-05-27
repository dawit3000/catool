# OverloadCompTool 0.0.0.9000

## Initial Development Release

🎉 **First release of OverloadCompTool!** This version introduces the core functionality to support fair and transparent overload compensation analysis for academic instructors. Key features include:

### Features
- `calculate_overload_compensation()`:
  - Computes prorated overload pay based on course credit hours (`HRS`) and student enrollment (`ENRLD`).
  - Handles per-course overload pay calculations.
  
- `get_instructor_schedule()`:
  - Extracts a specific instructor's schedule from the dataset.
  
- `summarize_instructor_by_index()` and `summarize_all_instructors()`:
  - Generate detailed overload pay summaries for individuals or all instructors.
  
- `list_unique_instructors()`:
  - Lists all distinct instructors in the dataset.

### Data
- `schedule`: Sample dataset with course schedules, instructors, credit hours, and enrollment.

### Internal Improvements
- Roxygen2 documentation for all functions and data
- `R CMD check`: Passed with **0 errors | 0 warnings | 0 notes**
- Ready for public release and future feature expansions

---

💡 For usage examples and assumptions, see the package vignette and function documentation.

