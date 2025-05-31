#' Filter Course Schedule by Subject Code (Regex-Friendly)
#'
#' Returns a subset of the schedule where the `SUBJ` (subject code) column matches a given pattern.
#' Matching is case-insensitive and supports regular expressions.
#'
#' @param subject_pattern A character string or regular expression to match subject codes.
#' @param schedule A data frame containing course schedule data with a `SUBJ` column.
#'
#' @return A filtered data frame containing only matching subject codes.
#'
#' @examples
#' schedule <- data.frame(SUBJ = c("CSCI", "MATH", "STAT"))
#' get_subject_schedule("CSCI", schedule)
#' get_subject_schedule("^MATH|^STAT", schedule)
#'
#' @export
get_subject_schedule <- function(subject_pattern, schedule) {
  result <- dplyr::filter(schedule, grepl(subject_pattern, SUBJ, ignore.case = TRUE))

  if (nrow(result) == 0) {
    warning(sprintf("No courses found matching subject pattern: '%s'", subject_pattern))
  }

  return(result)
}
