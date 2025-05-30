#' Filter Course Schedule by Instructor
#'
#' Returns a subset of the course schedule containing only the courses taught by the specified instructor.
#'
#' @param instructor_name A character string with the instructor's full name. Must exactly match a value in the `INSTRUCTOR` column.
#' @param schedule_df A data frame containing course schedule data with an `INSTRUCTOR` column.
#' Defaults to `schedule` if not specified.
#'
#' @return A data frame of courses assigned to the specified instructor.
#'
#' @examples
#' # get_instructor_schedule("Anderson-Robinson, Nataysha", schedule_df = schedule)
#'
#' @export
get_instructor_schedule <- function(instructor_name, schedule_df = schedule) {
  subset(schedule_df, INSTRUCTOR == instructor_name)
}
