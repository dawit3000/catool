#' Filter Course Schedule by Division
#'
#' Returns a subset of the course schedule for a specified academic division.
#' Users may optionally pass a custom subject map. If not provided, a default institutional map is used.
#'
#' @param division_name A character string naming the academic division.
#' @param schedule A data frame containing a `SUBJ` column (subject code).
#' @param subject_map Optional named list mapping division names to subject codes.
#'
#' @return A filtered data frame with only courses from the specified division.
#'
#' @examples
#' schedule <- data.frame(SUBJ = c("MATH", "NURS", "BIOL"))
#' get_division_schedule("Natural and Computational Sciences", schedule)
#' get_division_schedule("Nursing", schedule)
#' get_division_schedule("Nursing", schedule, subject_map = list(Nursing = "NURS"))
#'
#' @export
get_division_schedule <- function(division_name, schedule, subject_map = NULL) {
  if (is.null(subject_map)) {
    subject_map <- list(
      "College of ARTS and Sciences" = c(
        "COMM", "MCMM", "MUSC", "ARTH", "HUMN", "PHIL", "ENGL", "FREN", "SPAN",
        "CRJU", "POLS", "PSYC", "BHSC", "GERO", "SOWK", "HIST", "GEOG", "SOCI",
        "ACCT", "BUSA", "MNGT", "MKTG", "BLOG", "ECON",
        "BIOL", "ZOOL", "BOTN", "ANSC", "SCIE", "CHEM", "FVHP", "GEOL", "PHSC",
        "CSCI", "MATH", "STAT", "PHYS", "NURS"
      ),
      "Natural and Computational Sciences" = c(
        "BIOL", "ZOOL", "BOTN", "SCIE", "CHEM", "FVHP", "GEOL", "PHSC",
        "CSCI", "MATH", "STAT", "PHYS"
      ),
      "Arts and Communications" = c(
        "COMM", "MCMM", "MUSC", "ARTH", "HUMN", "PHIL", "ENGL", "FREN", "SPAN"
      ),
      "Behavioral and Social Sciences" = c(
        "CRJU", "POLS", "PSYC", "BHSC", "GERO", "SOWK", "HIST", "GEOG", "SOCI"
      ),
      "Business Administration" = c("ACCT", "BUSA", "MNGT", "MKTG", "BLOG", "ECON"),
      "Nursing" = c("NURS")
    )
  }

  matched_name <- names(subject_map)[tolower(names(subject_map)) == tolower(division_name)]

  if (length(matched_name) == 0) {
    stop(sprintf(
      "Unknown division: '%s'. Valid divisions are: %s",
      division_name,
      paste(names(subject_map), collapse = ", ")
    ))
  }

  subj_codes <- subject_map[[matched_name]]

  result <- dplyr::filter(schedule, SUBJ %in% subj_codes)

  if (nrow(result) == 0) {
    warning(sprintf("No courses found for division: '%s'", matched_name))
  }

  return(result)
}
