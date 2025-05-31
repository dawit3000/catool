#' Calculate Overload Compensation for One Instructor (by Index)
#'
#' Retrieves an instructor's name by index from the schedule and calculates their overload compensation
#' using [ol_comp()]. Returns a clean, readable summary with a labeled header row, consistent with the
#' Shiny App output.
#'
#' @param i Integer index of the instructor (as returned by [get_unique_instructors()]).
#' @param schedule_df A data frame of the full course schedule containing an `INSTRUCTOR` column.
#' @param L Lower enrollment threshold for overload eligibility (inclusive). Default is 4.
#' @param U Upper enrollment limit for proration (inclusive). Default is 9.
#' @param rate_per_cr Overload pay rate per credit hour. Default is 2500/3.
#' @param reg_load Regular teaching load in credit hours. Default is 12.
#'
#' @return Invisibly returns a tibble with the instructor’s overload compensation summary,
#' formatted for display.
#'
#' @examples
#' # Calculate overload compensation for the 5th instructor in the dataset:
#' # ol_comp_byindex(5, schedule_df = your_schedule_data)
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales dollar
#' @export
ol_comp_byindex <- function(i, schedule_df = schedule,
                            L = 4, U = 9,
                            rate_per_cr = 2500 / 3,
                            reg_load = 12) {
  instructor_name <- get_unique_instructors(schedule_df) %>%
    slice(i) %>%
    pull(INSTRUCTOR)

  summary <- ol_comp(
    get_instructor_schedule(instructor_name, schedule_df),
    L = L,
    U = U,
    rate_per_cr = rate_per_cr,
    reg_load = reg_load
  )

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
