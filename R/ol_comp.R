#' Calculate Overload Compensation for One Instructor
#'
#' Computes prorated overload pay and qualified credit hours for a single instructor
#' based on course credit hours, enrollment, and institutional overload rules.
#'
#' If `sort_order = "asc"`, the function still uses the highest-enrolled qualified courses
#' for compensation, but it reserves the lowest-enrolled qualified courses
#' (bottom of the list) toward the regular teaching load first. Compensation begins only after
#' `reg_load` credit hours are excluded from the bottom up — *preserving low-enrollment classes
#' as part of the regular load* and prioritizing compensation for higher-enrolled courses.
#'
#' @param instructor_schedule A data frame of the instructor's courses, with columns `INSTRUCTOR`, `ENRLD`, and `HRS`.
#' @param L Lower enrollment threshold for overload pay qualification (default = 4).
#' @param U Upper limit of proration; courses with ENRLD > U get full-rate pay (default = 9).
#' @param rate_per_cr Base overload pay per credit hour (default = 2500/3).
#' @param reg_load Regular teaching load in credit hours (default = 12).
#' @param sort_order Order in which to prioritize courses when counting toward the regular load.
#'   Options are "desc" (highest-enrollment courses first, default) or "asc" (lowest-enrollment first).
#'
#' @return A tibble with course-level compensation and a summary block, matching `ol_comp_summary()` format.
#'
#' @import dplyr
#' @import tibble
#' @importFrom scales comma
#' @export
ol_comp <- function(instructor_schedule, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12,
                    sort_order = c("desc", "asc")) {
  sort_order <- match.arg(sort_order)

  input <- instructor_schedule %>%
    mutate(
      ENRLD = as.numeric(ENRLD),
      HRS = as.numeric(HRS),
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

  if (sort_order == "desc") {
    total_hours <- max(0, sum(qualifying$HRS, na.rm = TRUE) - reg_load)
    remaining_hours <- sum(qualifying$HRS)
    m <- nrow(qualifying)

    while (remaining_hours > reg_load && m > 0) {
      hrs_to_count <- min(qualifying$HRS[m], remaining_hours - reg_load)
      pay_fraction <- min(qualifying$ENRLD[m], U + 1) / (U + 1)
      row_pay <- round(pay_fraction * rate_per_cr * hrs_to_count, 2)
      remaining_hours <- remaining_hours - qualifying$HRS[m]

      row_index <- qualifying$row_id[m]
      input$QUALIFIED_CR[row_index] <- hrs_to_count
      input$ROW_AMOUNT[row_index] <- row_pay

      if (qualifying$ENRLD[m] <= U) {
        input$TYPE[row_index] <- "PRORATED"
      }

      m <- m - 1
    }
  } else {
    qualifying <- qualifying %>% arrange(ENRLD)
    reg_remaining <- reg_load

    for (i in 1:nrow(qualifying)) {
      idx <- qualifying$row_id[i]
      hrs <- qualifying$HRS[i]
      enrld <- qualifying$ENRLD[i]

      if (reg_remaining >= hrs) {
        reg_remaining <- reg_remaining - hrs
      } else if (reg_remaining > 0) {
        qualified_hrs <- hrs - reg_remaining
        pay_fraction <- min(enrld, U + 1) / (U + 1)
        row_pay <- round(pay_fraction * rate_per_cr * qualified_hrs, 2)

        input$QUALIFIED_CR[idx] <- qualified_hrs
        input$ROW_AMOUNT[idx] <- row_pay
        if (enrld <= U) {
          input$TYPE[idx] <- "PRORATED"
        }

        reg_remaining <- 0
      } else {
        qualified_hrs <- hrs
        pay_fraction <- min(enrld, U + 1) / (U + 1)
        row_pay <- round(pay_fraction * rate_per_cr * qualified_hrs, 2)

        input$QUALIFIED_CR[idx] <- qualified_hrs
        input$ROW_AMOUNT[idx] <- row_pay
        if (enrld <= U) {
          input$TYPE[idx] <- "PRORATED"
        }
      }
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

  for (col in setdiff(names(input), names(summary_block))) {
    summary_block[[col]] <- NA
  }

  summary_block <- summary_block[, names(input)]

  bind_rows(input, summary_block) %>%
    mutate(across(everything(), ~ ifelse(is.na(.), "", .))) %>%
    select(-SUMMARY, SUMMARY)
}
