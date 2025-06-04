#' Calculate Overload Compensation for One Instructor
#'
#' Computes prorated overload pay and qualified credit hours for a single instructor
#' based on course credit hours, enrollment, and institutional overload rules.
#'
#' If `favor_institution = TRUE` (default), the function assigns **high-enrollment**
#' qualified courses to the **regular load first**, resulting in lower compensation
#' because only **low-enrollment** courses are left for overload pay — this favors the institution.
#'
#' If `favor_institution = FALSE`, the function assigns **low-enrollment** qualified
#' courses to the regular load first, preserving **high-enrollment** courses for compensation —
#' this favors the instructor.
#'
#' **Note:** This function assumes that `instructor_schedule` is already filtered for one instructor.
#' Use \code{get_instructor_schedule()} to extract an instructor’s schedule using
#' flexible, case-insensitive pattern matching (regex supported, e.g., `"smith|jones"`).
#'
#' @param instructor_schedule A data frame of the instructor's courses, with columns `INSTRUCTOR`, `ENRLD`, and `HRS`.
#' @param L Lower enrollment threshold for overload pay qualification (default = 4).
#' @param U Upper limit of proration; courses with ENRLD > U get full-rate pay (default = 9).
#' @param rate_per_cr Base overload pay per credit hour (default = 2500/3).
#' @param reg_load Regular teaching load in credit hours (default = 12).
#' @param favor_institution Logical: if TRUE (default), prioritizes high-enrollment courses for regular load.
#'
#' @return A tibble with course-level compensation and a human-readable summary block.
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales comma
#' @export
ol_comp <- function(instructor_schedule, L = 4, U = 9, rate_per_cr = 2500 / 3,
                    reg_load = 12, favor_institution = TRUE) {

  instructor_schedule <- instructor_schedule %>%
    mutate(
      ENRLD = as.numeric(trimws(ENRLD)),
      HRS = as.numeric(trimws(HRS))
    ) %>%
    filter(!is.na(HRS), !is.na(ENRLD))

  input <- instructor_schedule %>%
    mutate(
      QUALIFIED_CR = 0,
      ROW_AMOUNT = 0,
      TYPE = "",
      SUMMARY = ""
    ) %>%
    arrange(desc(ENRLD))

  instructor_name <- unique(input$INSTRUCTOR)[1]

  qualifying <- input %>%
    mutate(row_id = row_number()) %>%
    filter(ENRLD >= L, HRS > 0)

  qualifying <- if (favor_institution) {
    qualifying %>% arrange(desc(ENRLD))
  } else {
    qualifying %>% arrange(ENRLD)
  }

  reg_remaining <- reg_load

  for (i in seq_len(nrow(qualifying))) {
    idx <- qualifying$row_id[i]
    hrs <- qualifying$HRS[i]
    enrld <- qualifying$ENRLD[i]

    if (is.na(hrs) || is.na(enrld)) next

    if (reg_remaining >= hrs) {
      reg_remaining <- reg_remaining - hrs
    } else if (reg_remaining > 0) {
      qualified_hrs <- hrs - reg_remaining
      pay_fraction <- min(enrld, U + 1) / (U + 1)
      row_pay <- round(pay_fraction * rate_per_cr * qualified_hrs, 2)

      input$QUALIFIED_CR[idx] <- qualified_hrs
      input$ROW_AMOUNT[idx] <- row_pay
      if (enrld <= U) input$TYPE[idx] <- "PRORATED"

      reg_remaining <- 0
    } else {
      qualified_hrs <- hrs
      pay_fraction <- min(enrld, U + 1) / (U + 1)
      row_pay <- round(pay_fraction * rate_per_cr * qualified_hrs, 2)

      input$QUALIFIED_CR[idx] <- qualified_hrs
      input$ROW_AMOUNT[idx] <- row_pay
      if (enrld <= U) input$TYPE[idx] <- "PRORATED"
    }
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
    ROW_AMOUNT = c(total_comp, rep(NA, 7)),
    TYPE = c("TOTAL", rep(NA, 7)),
    SUMMARY = c(
      paste0("INSTRUCTOR: ", instructor_name),
      paste0("Over ", reg_load, " QUALIFIED CR. HRS: ", total_qualified),
      paste0("Overload Pay Rate: $", round(rate_per_cr, 2)),
      paste0("Total Overload Compensation: $", comma(total_comp, accuracy = 1)),
      note_line,
      "", "", ""
    )
  )

  # Add missing columns and fill with NA (same type as original input)
  for (col in setdiff(names(input), names(summary_block))) {
    summary_block[[col]] <- NA
  }

  summary_block <- summary_block[, names(input)]

  # Combine and return
  bind_rows(input, summary_block) %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .))) %>%
    select(-SUMMARY, SUMMARY)
}
