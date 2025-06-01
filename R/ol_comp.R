#' Calculate Overload Compensation for One Instructor
#'
#' Computes prorated overload pay and qualified credit hours for a single instructor
#' based on course credit hours, enrollment, and institutional overload rules.
#'
#' @param instructor_schedule A data frame of the instructor's courses, with columns `INSTRUCTOR`, `ENRLD`, and `HRS`.
#' @param L Lower enrollment threshold for overload pay qualification (default = 4).
#' @param U Upper limit of proration; courses with ENRLD > U get full-rate pay (default = 9).
#' @param rate_per_cr Base overload pay per credit hour (default = 2500/3).
#' @param reg_load Regular teaching load in credit hours (default = 12).
#'
#' @return A tibble with course-level compensation and a summary block, matching `ol_comp_summary()` format.
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales comma
#' @export
ol_comp <- function(instructor_schedule, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12) {
  input <- instructor_schedule %>%
    mutate(
      ENRLD = as.numeric(ENRLD),
      HRS = as.numeric(HRS),
      SUMMARY = "",
      QUALIFIED_CR = 0,
      ROW_AMOUNT = 0,
      TYPE = ""
    ) %>%
    arrange(desc(ENRLD))

  instructor_name <- unique(input$INSTRUCTOR)[1]

  qualifying <- input %>%
    mutate(row_id = row_number()) %>%
    filter(ENRLD >= L, HRS > 0)

  total_hours <- max(0, sum(qualifying$HRS, na.rm = TRUE) - reg_load)
  remaining_hours <- sum(qualifying$HRS)
  m <- nrow(qualifying)
  prorated_pay <- 0

  while (remaining_hours > reg_load && m > 0) {
    hrs_to_count <- min(qualifying$HRS[m], remaining_hours - reg_load)
    pay_fraction <- min(qualifying$ENRLD[m], U + 1) / (U + 1)
    row_pay <- pay_fraction * rate_per_cr * hrs_to_count
    prorated_pay <- prorated_pay + row_pay
    remaining_hours <- remaining_hours - qualifying$HRS[m]

    row_index <- qualifying$row_id[m]
    input$QUALIFIED_CR[row_index] <- hrs_to_count
    input$ROW_AMOUNT[row_index] <- row_pay

    if (qualifying$ENRLD[m] <= U) {
      input$TYPE[row_index] <- "PRORATED"
    }

    m <- m - 1
  }

  total_qualified <- sum(input$QUALIFIED_CR, na.rm = TRUE)
  total_comp <- sum(input$ROW_AMOUNT, na.rm = TRUE)
  any_prorated <- any(input$TYPE == "PRORATED")

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
      paste0("INSTRUCTOR: ", instructor_name),
      paste0("Over ", reg_load, " QUALIFIED CR. HRS: ", total_qualified),
      paste0("Overload Pay Rate: $", round(rate_per_cr, 2)),
      paste0("Total Overload Compensation: $", comma(total_comp, accuracy = 1)),
      note_line,
      "", "", ""
    )
  )

  # Add any missing columns from input
  missing_cols <- setdiff(names(input), names(summary_block))
  for (col in missing_cols) {
    sample_val <- input[[col]]
    template_value <- suppressWarnings(first(na.omit(sample_val), default = NA))

    if (is.numeric(template_value)) {
      summary_block[[col]] <- as.numeric(NA)
    } else if (is.logical(template_value)) {
      summary_block[[col]] <- as.logical(NA)
    } else {
      summary_block[[col]] <- as.character(NA)
    }
  }

  # Align column order and move SUMMARY to last
  summary_block <- summary_block[, names(input)] %>%
    mutate(SUMMARY = summary_block$SUMMARY) %>%
    select(-SUMMARY, SUMMARY)

  input <- input %>%
    select(-SUMMARY, SUMMARY)

  bind_rows(input, summary_block) %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .))) %>%
    select(-SUMMARY, SUMMARY)
}
