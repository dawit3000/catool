#' Schedule Data
#'
#' A dataset containing the schedule information.
#'
#' @description
#' This dataset represents a sample class schedule used by several institutions, with some variations in variable names.
#' Users are encouraged to ensure that the key variables—`HRS`, `ENRLD`, and `INSTRUCTOR`—are formatted correctly for the package to function properly.
#'
#' @details
#' The dataset has [number] rows and [number] columns, including:
#' \describe{
#'   \item{HRS}{Credit Hours of a course: int  3 3 3 3 3 3 3 0 3 0 ...}
#'   \item{ENRLD}{Number of students enrolled in a class: int  34 32 34 7 9 8 31 31 12 12 ...}
#'   \item{INSTRUCTOR}{Name of Instructor Teaching the course—real names changed; Char "Bui, Analie" "Calhoun, Alexandra" "Bui, Analie" "Davis, Kheylen" ...}
#' }
#'
#' @source [Insert any sources if applicable]
"schedule"
