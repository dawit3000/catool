# Suppress "no visible binding for global variable" notes during R CMD check
utils::globalVariables(c(
  # Input column names
  "INSTRUCTOR", "ENRLD", "HRS", "SUBJ", "DEPARTMENT", "COLLEGE", "PROGRAM",

  # Output variables in catool functions
  "INSTR", "QHRS", "PAY", "TYPE", "SUMMARY",

  # Constants or display labels (optional but clean)
  "schedule", "setNames", "Total Compensation (USD)", "Summary", "Overload Pay by Course"
))
