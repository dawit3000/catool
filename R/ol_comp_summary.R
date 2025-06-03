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
#' @param sort_order If "asc", reserves lowest-enrolled qualified courses toward regular load.
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
                            rate_per_cr = 2500 / 3, reg_load = 12, sort_order = c("desc", "asc")) {
  sort_order <- match.arg(sort_order)

  df <- schedule_df %>%
    filter(!is.na(.data$INSTRUCTOR)) %>%
    mutate(across(everything(), ~ ifelse(. == "", NA, .)))

  if (!is.null(instructor)) {
    df <- df %>% filter(.data$INSTRUCTOR == instructor)
  }

  instructors <- df %>%
    distinct(.data$INSTRUCTOR) %>%
    arrange(.data$INSTRUCTOR) %>%
    pull(.data$INSTRUCTOR)

  results <- purrr::map_dfr(instructors, function(instr) {
    course_table <- df %>%
      filter(.data$INSTRUCTOR == instr) %>%
      mutate(
        HRS = as.numeric(.data$HRS),
        ENRLD = as.numeric(.data$ENRLD)
      ) %>%
      arrange(desc(.data$ENRLD))

    comp_table <- ol_comp(course_table, L = L, U = U,
                          rate_per_cr = rate_per_cr, reg_load = reg_load, sort_order = sort_order)

    total_qualified <- sum(as.numeric(comp_table$QUALIFIED_CR), na.rm = TRUE)
    total_comp <- sum(as.numeric(comp_table$ROW_AMOUNT), na.rm = TRUE)
    any_prorated <- any(comp_table$TYPE == "PRORATED")

    note_line <- if (any_prorated) {
      "Note: Some compensation was prorated due to enrollment under 10."
    } else {
      ""
    }

    summary_block <- tibble(
      INSTRUCTOR = NA,
      COURSE = NA,
      HRS = NA,
      ENRLD = NA,
      QUALIFIED_CR = NA,
      ROW_AMOUNT = c(total_comp, NA, NA, NA, NA, NA, NA, NA),
      TYPE = c("TOTAL", NA, NA, NA, NA, NA, NA, NA),
      SUMMARY = c(
        paste0("INSTRUCTOR: ", instr),
        paste0("Over ", reg_load, " QUALIFIED CR. HRS: ", total_qualified),
        paste0("Overload Pay Rate: $", round(rate_per_cr, 2)),
        paste0("Total Overload Compensation: $", comma(total_comp, accuracy = 1)),
        note_line,
        "", "", ""
      )
    )

    missing_cols <- setdiff(names(comp_table), names(summary_block))
    for (col in missing_cols) {
      sample_val <- comp_table[[col]]
      template_value <- suppressWarnings(first(na.omit(sample_val), default = NA))

      if (is.numeric(template_value)) {
        summary_block[[col]] <- as.numeric(NA)
      } else if (is.logical(template_value)) {
        summary_block[[col]] <- as.logical(NA)
      } else {
        summary_block[[col]] <- as.character(NA)
      }
    }

    summary_block <- summary_block[, names(comp_table)] %>%
      mutate(SUMMARY = summary_block$SUMMARY) %>%
      select(everything(), SUMMARY)

    comp_table <- comp_table %>%
      select(everything(), SUMMARY)

    bind_rows(comp_table, summary_block)
  })

  results %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .)))
}
