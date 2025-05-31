#' Filter Course Schedule by Subject Code (Regex-Friendly)
#'
#' Returns a subset of the schedule where the `SUBJ` (subject code) column matches a given pattern.
#' Matching is case-insensitive and supports regular expressions.
#'
#' @param subject_pattern A character string or regular expression to match subject codes.
#' @param schedule_df A data frame containing course schedule data with a `SUBJ` column.
#'
#' @return A filtered data frame containing only matching subject codes.
#'
#' @examples
#' get_subject_schedule("CSCI", schedule_df)
#' get_subject_schedule("^MATH|^STAT", schedule_df)
#'
#' @export
get_subject_schedule <- function(subject_pattern, schedule_df) {
  result <- schedule_df %>%
    filter(grepl(subject_pattern, SUBJ, ignore.case = TRUE))
  
  if (nrow(result) == 0) {
    warning(sprintf("No courses found matching subject pattern: '%s'", subject_pattern))
  }
  
  return(result)
}
