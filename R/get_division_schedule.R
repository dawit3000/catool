#' Filter Course Schedule by Division
#'
#' Returns a subset of the schedule matching a named academic division. The function maps
#' division names to associated subject codes and filters accordingly.
#'
#' @param division_name A character string naming the division (must match one of the known values).
#' @param schedule A data frame containing course schedule data with a `SUBJ` column.
#'
#' @return A filtered data frame containing only courses in the specified division.
#'
#' @examples
#' schedule <- data.frame(SUBJ = c("MATH", "NURS", "BIOL"))
#' get_division_schedule("Natural and Computational Sciences", schedule)
#' get_division_schedule("Nursing", schedule)
#'
#' @export
get_division_schedule <- function(division_name, schedule) {
  subject_map <- list(
    "College of ARTS and Sciences" = c("COMM", "MCMM", "MUSC", "ARTH", "HUMN", "PHIL", "ENGL", "FREN", "SPAN",
                                       "CRJU", "POLS", "PSYC", "BHSC", "GERO", "SOWK", "HIST", "GEOG", "SOCI",
                                       "ACCT", "BUSA", "MNGT", "MKTG", "BLOG", "ECON",
                                       "BIOL", "ZOOL", "BOTN", "ANSC", "SCIE", "CHEM", "FVHP", "GEOL", "PHSC",
                                       "CSCI", "MATH", "STAT", "PHYS", "NURS"),
    "Natural and Computational Sciences" = c("BIOL", "ZOOL", "BOTN", "SCIE", "CHEM", "FVHP", "GEOL", "PHSC", "CSCI", "MATH", "STAT", "PHYS"),
    "Arts and Communications" = c("COMM", "MCMM", "MUSC", "ARTH", "HUMN", "PHIL", "ENGL", "FREN", "SPAN"),
    "Behavioral and Social Sciences" = c("CRJU", "POLS", "PSYC", "BHSC", "GERO", "SOWK", "HIST", "GEOG", "SOCI"),
    "Business Administration" = c("ACCT", "BUSA", "MNGT", "MKTG", "BLOG", "ECON"),
    "Nursing" = c("NURS")
  )

  subj_codes <- subject_map[[division_name]]

  if (is.null(subj_codes)) {
    stop(sprintf("Unknown division: '%s'. Check spelling or use one of: %s",
                 division_name, paste(names(subject_map), collapse = ", ")))
  }

  result <- dplyr::filter(schedule, SUBJ %in% subj_codes)

  if (nrow(result) == 0) {
    warning(sprintf("No courses found for division: '%s'", division_name))
  }

  return(result)
}
