#' Sample Schedule Dataset
#'
#' A dataset containing instructor schedules for overload analysis.
#'
#' @description
#' This dataset represents a sample class schedule used by several institutions, with slight variations in variable names.
#' Users must ensure that the key variables—`HRS`, `ENRLD`, and `INSTRUCTOR`—are properly named and formatted for the functions in this package to work correctly.
#'
#' @details
#' The dataset has 665 rows and 15 columns, including:
#' \describe{
#'   \item{HRS}{Credit hours of the course.}
#'   \item{ENRLD}{Number of students enrolled in the course.}
#'   \item{INSTRUCTOR}{Name of the instructor teaching the course (anonymized).}
#' }
#'
#' @source Included in the package under `data/schedule.rda`
"schedule"
