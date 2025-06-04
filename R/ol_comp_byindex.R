#' Calculate Overload Compensation for One Instructor (by Index)
#'
#' Retrieves an instructor's name by index from the schedule and calculates their overload compensation
#' using \code{ol_comp()}. Returns a clean, readable course-level compensation summary.
#'
#' If \code{favor_institution = TRUE} (default), the function assigns high-enrollment
#' courses to the regular load first, minimizing compensation.
#'
#' If \code{favor_institution = FALSE}, low-enrollment courses are used toward the regular load first,
#' preserving high-enrollment courses for overload pay.
#'
#' @param i Integer index of the instructor (as returned by \code{get_unique_instructors()}).
#' @param schedule_df A data frame of the full course schedule containing an \code{INSTRUCTOR} column.
#' @param L Lower enrollment threshold for overload pay eligibility (inclusive). Default is 4.
#' @param U Upper enrollment limit for proration (inclusive). Default is 9.
#' @param rate_per_cr Overload pay rate per qualified credit hour. Default is 2500/3.
#' @param reg_load Regular teaching load in credit hours. Default is 12.
#' @param favor_institution Logical: if TRUE (default), favors the institution by prioritizing
#'   high-enrollment courses for regular load.
#'
#' @return Invisibly returns a tibble with the instructor’s course-level overload compensation summary.
#' Also prints a formatted version to the console.
#'
#' @examples
#' # Example usage with a schedule dataframe:
#' # ol_comp_byindex(1, schedule_df = schedule)
#'
#' @import dplyr
#' @export
ol_comp_byindex <- function(i, schedule_df, L = 4, U = 9, rate_per_cr = 2500 / 3,
                            reg_load = 12, favor_institution = TRUE) {

  instructor_list <- get_unique_instructors(schedule_df)

  if (i < 1 || i > length(instructor_list)) {
    stop("Index 'i' is out of bounds. Check the number of instructors in your dataset.")
  }

  instructor_name <- instructor_list[i]

  instructor_sched <- get_instructor_schedule(instructor_name, schedule_df)

  summary <- ol_comp(
    instructor_sched,
    L = L,
    U = U,
    rate_per_cr = rate_per_cr,
    reg_load = reg_load,
    favor_institution = favor_institution
  )

  summary %>%
    mutate(across(
      everything(),
      ~ if (is.character(.)) {
        ifelse(. == "" | is.na(.), " ", .)
      } else {
        ifelse(is.na(.), " ", .)
      }
    )) %>%
    print()

  invisible(summary)
}
