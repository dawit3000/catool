# Suppress "no visible binding for global variable" notes
utils::globalVariables(c(
  # Column names from data frames
  "COLLEGE",
  "DEPARTMENT",
  "ENRLD",
  "HRS",
  "INSTRUCTOR",
  "PROGRAM",
  "SUBJ",

  # Internal objects or constants
  "schedule",
  "setNames",

  # Column labels or dynamic text used in output
  "Overload Pay by Course",
  "Summary",
  "SUMMARY",
  "Total Compensation (USD)"
))
