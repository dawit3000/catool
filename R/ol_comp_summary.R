#' Summarize Overload Compensation for One or All Instructors
#'
#' Calculates overload compensation for each instructor (or a selected one) based on institutional policies.
#' Output includes course-level pay, qualified credit hours, and a readable summary section for each instructor.
#'
#' @param schedule_df A data frame containing the full course schedule, including `INSTRUCTOR`, `HRS`, and `ENRLD`.
#' @param instructor Optional string. If provided, limits output to that instructor. Default is NULL (all).
#' @param L Lower enrollment threshold for overload eligibility (default = 4).
#' @param U Upper limit of proration. ENRLD > U gets full-rate pay (default = 9).
#' @param rate_per_cr Pay rate per credit hour (default = 2500/3).
#' @param reg_load Regular teaching load in credit hours (default = 12).
#'
#' @return A tibble combining course-level pay and instructor summaries for one or more instructors.
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales comma
#' @importFrom rlang .data
#' @export
ol_comp_summary <- function(schedule_df, instructor = NULL, L = 4, U = 9,
                            rate_per_cr = 2500 / 3, reg_load = 12) {
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
      arrange(desc(.data$ENRLD)) %>%
      mutate(
        is_qualified = .data$ENRLD >= L,
        qualified_cr = if_else(.data$is_qualified, .data$HRS, 0)
      ) %>%
      mutate(cum_qualified = cumsum(.data$qualified_cr)) %>%
      mutate(QUALIFIED_CR = pmax(0, .data$cum_qualified - reg_load)) %>%
      mutate(QUALIFIED_CR = pmin(.data$QUALIFIED_CR, .data$qualified_cr)) %>%
      mutate(
        prorated_rate = case_when(
          .data$ENRLD > U ~ rate_per_cr,
          .data$ENRLD >= L  ~ rate_per_cr * .data$ENRLD / 10,
          TRUE              ~ 0
        ),
        ROW_AMOUNT = round(.data$prorated_rate * .data$QUALIFIED_CR, 2),
        TYPE = case_when(
          .data$QUALIFIED_CR > 0 & .data$ENRLD <= U ~ "PRORATED",
          .data$QUALIFIED_CR > 0 & .data$ENRLD > U ~ "",
          TRUE ~ ""
        ),
        SUMMARY = ""
      ) %>%
      select(-.data$qualified_cr, -.data$cum_qualified, -.data$is_qualified, -.data$prorated_rate)

    total_qualified <- sum(course_table$QUALIFIED_CR, na.rm = TRUE)
    total_comp <- sum(course_table$ROW_AMOUNT, na.rm = TRUE)
    any_prorated <- any(course_table$TYPE == "PRORATED")

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

    missing_cols <- setdiff(names(course_table), names(summary_block))
    for (col in missing_cols) {
      template_value <- course_table[[col]][[1]]
      if (is.numeric(template_value)) {
        summary_block[[col]] <- as.numeric(NA)
      } else if (is.logical(template_value)) {
        summary_block[[col]] <- as.logical(NA)
      } else {
        summary_block[[col]] <- as.character(NA)
      }
    }

    summary_block <- summary_block[, names(course_table)] %>%
      mutate(SUMMARY = summary_block$SUMMARY) %>%
      select(everything(), SUMMARY)

    course_table <- course_table %>%
      select(everything(), SUMMARY)

    bind_rows(course_table, summary_block)
  })

  results %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .)))
}
