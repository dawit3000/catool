#' Summarize Overload Compensation for All Instructors
#'
#' Applies the overload compensation calculation to each unique instructor
#' in the schedule and combines the results into one formatted summary table.
#'
#' @param schedule_df A data frame containing course schedule data with an `INSTRUCTOR` column.
#' Defaults to `schedule` if not specified.
#' @param L Lower enrollment bound for overload eligibility (inclusive). Default is 4.
#' @param U Upper bound for proration (inclusive). Default is 9.
#' @param rate_per_cr Overload pay rate per credit hour. Default is 2500/3.
#' @param reg_load Regular teaching load in credit hours. Default is 12.
#'
#' @return A tibble with formatted overload compensation summaries for all instructors.
#'
#' @examples
#' # ol_comp_summary(schedule)
#'
#' @import dplyr
#' @import purrr
#' @importFrom tibble as_tibble
#' @importFrom scales dollar
#' @export
ol_comp_summary <- function(schedule_df = schedule,
                            L = 4, U = 9,
                            rate_per_cr = 2500 / 3,
                            reg_load = 12) {
  instructor_list <- get_unique_instructors(schedule_df) %>% dplyr::pull(INSTRUCTOR)

  all_outputs <- purrr::map(seq_along(instructor_list), function(i) {
    result <- ol_comp_byindex(i, schedule_df,
                              L = L, U = U,
                              rate_per_cr = rate_per_cr,
                              reg_load = reg_load)
    spacer <- tibble::as_tibble(setNames(rep(list(""), ncol(result)), names(result)))
    dplyr::bind_rows(result, spacer)
  })

  final_result <- dplyr::bind_rows(all_outputs)

  cols <- names(final_result)
  special_cols <- c("Overload Pay by Course", "Summary", "Total Compensation (USD)")
  present_special <- intersect(special_cols, cols)
  target_order <- c(setdiff(cols, present_special), present_special)
  final_result <- final_result[, target_order, drop = FALSE]

  final_result <- final_result %>%
    dplyr::mutate(
      `Overload Pay by Course` = dplyr::if_else(
        suppressWarnings(!is.na(as.numeric(`Overload Pay by Course`)) &
                           as.numeric(`Overload Pay by Course`) > 0),
        scales::dollar(as.numeric(`Overload Pay by Course`)),
        `Overload Pay by Course`
      ),
      dplyr::across(dplyr::everything(), ~ ifelse(is.na(.), "", .))
    )

  return(final_result)
}
