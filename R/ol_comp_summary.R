#' Summarize Overload Compensation
#'
#' Calculates overload compensation for each instructor based on institutional policy.
#' The output includes course-level payments, qualified credit hours, and a readable
#' instructor-level summary block that follows each instructor's courses.
#'
#' @param schedule_df A data frame containing course schedule information. Must include
#'   columns such as `INSTRUCTOR`, `HRS`, and `ENRLD`.
#' @param instructor Optional string. If provided, limits the summary to a single instructor.
#'   Default is NULL (includes all instructors).
#' @param L Minimum enrollment required for overload pay eligibility. Default is 4.
#' @param U Upper threshold for proration. Courses with ENRLD > U receive full-rate pay.
#'   Default is 9.
#' @param rate_per_cr Overload pay rate per credit hour. Default is 2500/3.
#' @param reg_load Regular teaching load in credit hours. Default is 12.
#' @param favor_institution Logical: if TRUE (default), prioritizes high-enrollment courses for regular load.
#'
#' @return A tibble combining course-level compensation and a summary section for each instructor.
#' @importFrom stats na.omit
#' @import dplyr
#' @import tibble
#' @importFrom purrr map_dfr
#' @importFrom scales comma
#' @importFrom rlang .data
#' @export
ol_comp_summary <- function(schedule_df, instructor = NULL, L = 4, U = 9,
                            rate_per_cr = 2500 / 3, reg_load = 12,
                            favor_institution = TRUE) {

  df <- schedule_df %>%
    filter(!is.na(.data$INSTRUCTOR), .data$INSTRUCTOR != "") %>%
    mutate(across(everything(), ~ ifelse(. == "", NA, .))) %>%
    mutate(HRS = as.numeric(.data$HRS), ENRLD = as.numeric(.data$ENRLD)) %>%
    filter(!is.na(HRS) & !is.na(ENRLD))  # ✅ Filter out incomplete rows

  if (!is.null(instructor)) {
    df <- df %>% filter(.data$INSTRUCTOR == instructor)
  }

  instructors <- df %>%
    distinct(.data$INSTRUCTOR) %>%
    arrange(.data$INSTRUCTOR) %>%
    pull(.data$INSTRUCTOR)

  results <- purrr::map_dfr(instructors, function(instr) {
    course_table <- df %>%
      filter(.data$INSTRUCTOR == instr)

    comp_table <- ol_comp(course_table, L = L, U = U,
                          rate_per_cr = rate_per_cr, reg_load = reg_load,
                          favor_institution = favor_institution)

    comp_table
  })

  results %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .)))
}
