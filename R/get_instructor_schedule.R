#' Get an Instructor's Course Schedule
#'
#' Returns the subset of a schedule data frame containing only the rows
#' for a specific instructor.
#'
#' @param instructor_name A character string with the instructor's name (must match `INSTRUCTOR` column exactly).
#' @param schedule_df A data frame containing a column named `INSTRUCTOR`. Defaults to `schedule` if available in the environment.
#'
#' @return A data frame of the instructor’s schedule.
#'
#' @examples
#' # IS <- get_instructor_schedule("Anderson-Robinson, Nataysha", schedule_df = schedule)
#'
#' @export
get_instructor_schedule <- function(instructor_name, schedule_df = schedule) {
  subset(schedule_df, INSTRUCTOR == instructor_name)
}
