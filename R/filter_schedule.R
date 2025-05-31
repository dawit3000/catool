#' Filter Course Schedule by Division, Subject, and/or Instructor
#'
#' Applies one or more filters to a course schedule: by instructor name (regex), subject code (regex),
#' and/or academic division. Matching is case-insensitive and all filters are optional.
#'
#' @param schedule_df A data frame containing the course schedule with `INSTRUCTOR` and `SUBJ` columns.
#' @param division Optional character string naming a division (must match known values).
#' @param subject_pattern Optional regex pattern for filtering subject codes (e.g., "CSCI", "^MATH").
#' @param instructor_pattern Optional regex pattern for instructor name (e.g., "Smith", "^Jones").
#'
#' @return A filtered course schedule data frame.
#'
#' @examples
#' filter_schedule(schedule_df, division = "Nursing")
#' filter_schedule(schedule_df, subject_pattern = "^MATH|^STAT")
#' filter_schedule(schedule_df, instructor_pattern = "smith")
#' filter_schedule(schedule_df, division = "Business Administration", instructor_pattern = "Lee")
#'
#' @export
filter_schedule <- function(schedule_df,
                            division = NULL,
                            subject_pattern = NULL,
                            instructor_pattern = NULL) {
  df <- schedule_df
  
  if (!is.null(division)) {
    df <- get_division_schedule(division, df)
  }
  
  if (!is.null(subject_pattern)) {
    df <- get_subject_schedule(subject_pattern, df)
  }
  
  if (!is.null(instructor_pattern)) {
    df <- df %>%
      filter(grepl(instructor_pattern, INSTRUCTOR, ignore.case = TRUE))
  }
  
  if (nrow(df) == 0) {
    warning("No records found after applying filters.")
  }
  
  return(df)
}
