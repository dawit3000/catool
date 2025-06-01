#' Filter Course Schedule by Instructor (Regex-Friendly, Case-Insensitive)
#'
#' Returns a subset of the course schedule containing courses taught by the specified instructor.
#' Matching is case-insensitive and supports regular expressions, allowing flexible partial or pattern-based matching.
#' If no match is found, a warning is issued and an empty data frame is returned.
#'
#' @param instructor_name A character string (or regular expression) used to match against values in the `INSTRUCTOR` column.
#' @param schedule_df A data frame containing course schedule data with an `INSTRUCTOR` column.
#' Defaults to `schedule` if not specified.
#'
#' @return A data frame of courses assigned to instructors matching the given pattern, sorted by descending enrollment.
#'
#' @examples
#' get_instructor_schedule("smith", schedule_df = schedule)  # partial match
#' get_instructor_schedule("^Smith,", schedule_df = schedule)  # regex: starts with Smith
#' get_instructor_schedule("Robinson|Smith", schedule_df = schedule)  # regex: matches either
#'
#' @import dplyr
#' @export
get_instructor_schedule <- function(instructor_name, schedule_df = schedule) {
  result <- schedule_df %>%
    filter(
      !is.na(INSTRUCTOR),
      INSTRUCTOR != "",
      grepl(instructor_name, INSTRUCTOR, ignore.case = TRUE)
    ) %>%
    arrange(desc(ENRLD))

  if (nrow(result) == 0) {
    warning(sprintf("No courses found matching instructor name: '%s'", instructor_name))
  }

  return(result)
}
