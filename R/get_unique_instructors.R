#' Get Unique Instructor Names
#'
#' Extracts a sorted list of unique, non-empty instructor names from a schedule data frame.
#'
#' @param schedule_df A data frame containing an `INSTRUCTOR` column.
#'
#' @return A data frame with one column: unique instructor names sorted alphabetically.
#'
#' @examples
#' # get_unique_instructors(schedule)
#'
#' @import dplyr
#' @export
get_unique_instructors <- function(schedule_df) {
  schedule_df %>%
    distinct(INSTRUCTOR) %>%
    filter(!is.na(INSTRUCTOR), INSTRUCTOR != "") %>%
    arrange(INSTRUCTOR)
}
