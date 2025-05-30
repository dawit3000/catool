## Test environments
* Local Windows 11, R 4.4.0
* devtools::check() results:
  0 errors ✔ | 0 warnings ✔ | 3 notes ✖

## R CMD check notes

### 1. Undefined global functions or variables
> ol_comp_byindex: no visible global function definition for ‘get_unique_instructors’  
> ol_comp_summary: no visible global function definition for ‘get_unique_instructors’

These are standard tidyverse evaluation issues. I have addressed this with:
```r
utils::globalVariables(c("get_unique_instructors"))
