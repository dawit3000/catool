#' Summarize Overload Compensation for All Instructors
#'
#' Applies the overload compensation calculation to each unique instructor
#' in the schedule and combines the results into one formatted table.
#'
#' @param schedule_df A data frame containing course schedule data with an `INSTRUCTOR` column.
#' Defaults to `schedule` if not specified.
#'
#' @return A tibble summarizing overload compensation for each instructor,
#' with formatted compensation and a summary row per instructor.
#' @param rate_per_cr Numeric value indicating the rate paid per credit hour.
#' @param L Lower bound of enrollment illegible for peroration (inclusive)
#' @param U Upper bound of enrollment illegible for peroration (inclusive)
#' @param reg_load A numeric value indicating the regular teaching load (in credit hours).
#'
#' @examples
#' # summarize_all_instructors(schedule)
#'
#' @import dplyr
#' @import purrr
#' @importFrom tibble as_tibble
#' @importFrom scales dollar
#' @export
summarize_all_instructors <- function(schedule_df = schedule,
                                      L = 4, U = 9,
                                      rate_per_cr = 2500 / 3,
                                      reg_load = 12) {
  instructor_list <- list_unique_instructors(schedule_df) %>% pull(INSTRUCTOR)

  all_outputs <- map(seq_along(instructor_list), function(i) {
    result <- summarize_instructor_by_index(i, schedule_df,
                                            L = L, U = U,
                                            rate_per_cr = rate_per_cr,
                                            reg_load = reg_load)
    spacer <- as_tibble(setNames(rep(list(""), ncol(result)), names(result)))
    bind_rows(result, spacer)
  })

  final_result <- bind_rows(all_outputs)

  cols <- names(final_result)
  target_order <- c(
    setdiff(cols, c("Overload Pay by Course", "Summary", "Total Compensation (USD)")),
    "Overload Pay by Course", "Summary", "Total Compensation (USD)"
  )
  final_result <- final_result[, target_order]

  final_result <- final_result %>%
    mutate(
      `Overload Pay by Course` = ifelse(
        suppressWarnings(!is.na(as.numeric(`Overload Pay by Course`)) & as.numeric(`Overload Pay by Course`) > 0),
        dollar(as.numeric(`Overload Pay by Course`)),
        `Overload Pay by Course`
      ),
      across(everything(), ~ ifelse(is.na(.), "", .))
    )

  final_result
}
