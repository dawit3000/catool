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
    rename(INSTR = INSTRUCTOR) %>%
    mutate(
      QHRS = 0,
      PAY = 0,
      TYPE = "",
      SUMMARY = ""
    ) %>%
    arrange(desc(ENRLD))

  instructor_name <- unique(input$INSTR)[1]

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

      input$QHRS[idx] <- qualified_hrs
      input$PAY[idx] <- row_pay
      if (enrld <= U) input$TYPE[idx] <- "PRO"

      reg_remaining <- 0
    } else {
      qualified_hrs <- hrs
      pay_fraction <- min(enrld, U + 1) / (U + 1)
      row_pay <- round(pay_fraction * rate_per_cr * qualified_hrs, 2)

      input$QHRS[idx] <- qualified_hrs
      input$PAY[idx] <- row_pay
      if (enrld <= U) input$TYPE[idx] <- "PRO"
    }
  }

  total_qualified <- sum(input$QHRS, na.rm = TRUE)
  total_comp <- sum(input$PAY, na.rm = TRUE)

  summary_block <- tibble(
    INSTR = NA,
    SUBJ = NA,
    HRS = NA,
    ENRLD = NA,
    QHRS = NA,
    PAY = c(total_comp, rep(NA, 7)),
    TYPE = c("TOT", rep(NA, 7)),
    SUMMARY = c(
      paste0("INSTRUCTOR: ", instructor_name),
      paste0("Over ", reg_load, " QHRS: ", total_qualified),
      paste0("Overload Pay Rate: $", round(rate_per_cr, 2)),
      paste0("Total Overload: $", format(round(total_comp, 2), nsmall = 2)),
      "Note: ENRLD<U+1 PRO or NO",
      "", "", ""
    )
  )

  for (col in setdiff(names(input), names(summary_block))) {
    summary_block[[col]] <- NA
  }
  summary_block <- summary_block[, names(input)]

  bind_rows(input, summary_block) %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .))) %>%
    select(-SUMMARY, SUMMARY)
}
