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
#' @export
ol_comp_summary <- function(schedule_df, instructor = NULL, L = 4, U = 9,
                            rate_per_cr = 2500 / 3, reg_load = 12) {
  df <- schedule_df %>%
    filter(!is.na(INSTRUCTOR)) %>%
    mutate(across(everything(), ~ ifelse(. == "", NA, .)))

  if (!is.null(instructor)) {
    df <- df %>% filter(INSTRUCTOR == instructor)
  }

  instructors <- df %>%
    distinct(INSTRUCTOR) %>%
    arrange(INSTRUCTOR) %>%
    pull(INSTRUCTOR)

  results <- purrr::map_dfr(instructors, function(instr) {
    course_table <- df %>%
      filter(INSTRUCTOR == instr) %>%
      mutate(
        HRS = as.numeric(HRS),
        ENRLD = as.numeric(ENRLD)
      ) %>%
      arrange(desc(ENRLD)) %>%
      mutate(
        is_qualified = ENRLD >= L,
        qualified_cr = if_else(is_qualified, HRS, 0)
      ) %>%
      mutate(cum_qualified = cumsum(qualified_cr)) %>%
      mutate(QUALIFIED_CR = pmax(0, cum_qualified - reg_load)) %>%
      mutate(QUALIFIED_CR = pmin(QUALIFIED_CR, qualified_cr)) %>%
      mutate(
        prorated_rate = case_when(
          ENRLD >= 10 ~ rate_per_cr,
          ENRLD >= L  ~ rate_per_cr * ENRLD / 10,
          TRUE        ~ 0
        ),
        ROW_AMOUNT = round(prorated_rate * QUALIFIED_CR, 2),
        TYPE = case_when(
          QUALIFIED_CR > 0 & ENRLD < 10 ~ "PRORATED",
          QUALIFIED_CR > 0 & ENRLD >= 10 ~ "UNPRORATED",
          TRUE ~ ""
        ),
        SUMMARY = ""
      ) %>%
      select(-qualified_cr, -cum_qualified, -is_qualified, -prorated_rate)

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
