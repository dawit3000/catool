#' Get Unique Instructor Names
#'
#' Extracts a sorted vector of unique, non-empty instructor names from a schedule data frame.
#'
#' @param schedule_df A data frame containing an `INSTRUCTOR` column.
#'
#' @return A character vector of instructor names, sorted alphabetically.
#'
#' @examples
#' get_unique_instructors(schedule)
#'
#' @import dplyr
#' @export
get_unique_instructors <- function(schedule_df) {
  schedule_df %>%
    filter(!is.na(INSTRUCTOR), INSTRUCTOR != "") %>%
    distinct(INSTRUCTOR) %>%
    arrange(INSTRUCTOR) %>%
    pull(INSTRUCTOR)
}
