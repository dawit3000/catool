#' Summarize Overload Compensation for One Instructor (by Index)
#'
#' Retrieves the instructor by index from the schedule, calculates their overload compensation,
#' and prints a clean, readable summary with a header row.
#'
#' @param i Integer index of the instructor (from `list_unique_instructors()`).
#' @param schedule_df A data frame containing course schedule data with an `INSTRUCTOR` column.
#'
#' @return Invisibly returns a tibble with the instructor’s overload compensation summary.
#'
#' @examples
#' # summarize_instructor_by_index(5)
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales dollar
#' @export
summarize_instructor_by_index <- function(i, schedule_df = schedule) {
  instructor_name <- list_unique_instructors(schedule_df) %>%
    slice(i) %>%
    pull(INSTRUCTOR)

  summary <- calculate_overload_compensation(get_instructor_schedule(instructor_name, schedule_df))

  header <- tibble(
    `Overload Pay by Course` = NA_character_,
    Summary = paste("INSTRUCTOR:", instructor_name),
    `Total Compensation (USD)` = NA_character_
  )

  result <- bind_rows(header, summary)

  all_cols <- names(result)
  result <- result[, c(
    setdiff(all_cols, c("Overload Pay by Course", "Summary", "Total Compensation (USD)")),
    "Overload Pay by Course", "Summary", "Total Compensation (USD)"
  )]

  display <- result %>%
    mutate(across(
      everything(),
      ~ {
        if (is.character(.x)) {
          ifelse(.x == "" | is.na(.x), " ", .x)
        } else {
          ifelse(is.na(.x), " ", .x)
        }
      }
    ))

  print(as.data.frame(display), row.names = FALSE)
  invisible(result)
}
