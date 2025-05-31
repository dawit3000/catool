#' Calculate Overload Compensation for One Instructor
#'
#' Computes prorated overload pay and qualified credit hours for a single instructor
#' based on course credit hours, enrollment, and institutional overload rules.
#'
#' @param instructor_schedule A data frame of the instructor's courses, with columns `ENRLD` (enrollment) and `HRS` (credit hours).
#' @param L Lower enrollment threshold for overload pay qualification (default = 4).
#' @param U Upper limit of proration; courses with ENRLD > U get full-rate pay (default = 9).
#' @param rate_per_cr Base overload pay per credit hour (default = 2500/3).
#' @param reg_load Regular teaching load in credit hours (default = 12).
#'
#' @return A tibble with original schedule, overload pay by course, and a summary block.
#'
#' @import dplyr
#' @importFrom scales dollar
#' @export
ol_comp <- function(instructor_schedule, L = 4, U = 9, rate_per_cr = 2500 / 3, reg_load = 12) {
  input <- instructor_schedule %>%
    mutate(
      ENRLD = as.numeric(ENRLD),
      HRS = as.numeric(HRS),
      Summary = "",
      `Total Compensation (USD)` = "",
      `Overload Pay by Course` = 0
    ) %>%
    arrange(desc(ENRLD))

  qualifying <- input %>%
    mutate(row_id = row_number()) %>%
    filter(ENRLD >= L, HRS > 0)

  total_hours <- max(0, sum(qualifying$HRS, na.rm = TRUE) - reg_load)
  prorated_pay <- 0
  remaining_hours <- sum(qualifying$HRS)
  m <- nrow(qualifying)

  while (remaining_hours > reg_load && m > 0) {
    hrs_to_count <- min(qualifying$HRS[m], remaining_hours - reg_load)
    pay_fraction <- min(qualifying$ENRLD[m], U + 1) / (U + 1)
    row_pay <- pay_fraction * rate_per_cr * hrs_to_count
    prorated_pay <- prorated_pay + row_pay
    remaining_hours <- remaining_hours - qualifying$HRS[m]

    row_index <- qualifying$row_id[m]
    input$`Overload Pay by Course`[row_index] <- input$`Overload Pay by Course`[row_index] + row_pay

    m <- m - 1
  }

  count <- qualifying %>% filter(ENRLD <= U) %>% nrow()

  note_text <- if (count > 0 && prorated_pay > 0) {
    "Classes with 4 <= ENRLD <= 9 were prorated."
  } else {
    ""
  }

  summary_rows <- tibble(
    Summary = c(
      paste0("Over ", reg_load, " QUALIFIED CR. HRS:"),
      "OVERLOAD PAY:",
      "NOTE:"
    ),
    `Total Compensation (USD)` = c(
      total_hours,
      dollar(prorated_pay),
      note_text
    ),
    `Overload Pay by Course` = c(NA_real_, NA_real_, NA_real_)
  )

  final_result <- bind_rows(input, summary_rows)

  all_cols <- names(final_result)
  final_result <- final_result[, c(
    setdiff(all_cols, c("Overload Pay by Course", "Summary", "Total Compensation (USD)")),
    "Overload Pay by Course", "Summary", "Total Compensation (USD)"
  )]

  final_result %>%
    mutate(
      `Overload Pay by Course` = ifelse(
        suppressWarnings(!is.na(as.numeric(`Overload Pay by Course`)) &
                           as.numeric(`Overload Pay by Course`) > 0),
        dollar(as.numeric(`Overload Pay by Course`)),
        `Overload Pay by Course`
      ),
      across(everything(), ~ ifelse(is.na(.), "", .))
    )
}

