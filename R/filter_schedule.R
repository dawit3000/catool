#' Filter Course Schedule by College, Department, Program, Subject, and/or Instructor
#'
#' Applies one or more filters to a course schedule using pattern matching on instructor, subject,
#' college, department, and program. All matching is case-insensitive and based on partial string matching.
#'
#' @param schedule A data frame containing the course schedule with required columns: `INSTRUCTOR`, `SUBJ`.
#'        Optional columns include: `COLLEGE`, `DEPARTMENT`, `PROGRAM`.
#' @param subject_pattern Optional regex pattern to match subject codes (e.g., "CSCI", "^MATH").
#' @param instructor_pattern Optional regex pattern to match instructor names (e.g., "Smith", "^Jones").
#' @param college_pattern Optional regex pattern to match college names (e.g., "Science", "Engineering").
#' @param department_pattern Optional regex pattern to match department names (e.g., "Math", "Biology").
#' @param program_pattern Optional regex pattern to match program names (e.g., "Undergraduate", "MBA").
#'
#' @return A filtered data frame of matching courses.
#'
#' @examples
#' schedule <- data.frame(
#'   INSTRUCTOR = c("Lee", "Smith", "Jones", "Dawson", "Garcia"),
#'   SUBJ = c("MATH", "NURS", "CSCI", "ENGL", "COMM"),
#'   COLLEGE = c("Science", "Nursing", "Science", "Arts and Sciences", "Arts and Communication"),
#'   DEPARTMENT = c("Math", "Nursing", "CS", "English", "Comm Studies"),
#'   PROGRAM = c("BS", "BSN", "BS", "BA", "BA"),
#'   stringsAsFactors = FALSE
#' )
#'
#' filter_schedule(schedule, subject_pattern = "^MATH|^STAT")
#' filter_schedule(schedule, instructor_pattern = "smith")
#' filter_schedule(schedule, college_pattern = "Science")
#' filter_schedule(schedule, department_pattern = "Comm")
#' filter_schedule(schedule, program_pattern = "^BA$")
#'
#' @export
filter_schedule <- function(schedule,
                            subject_pattern = NULL,
                            instructor_pattern = NULL,
                            college_pattern = NULL,
                            department_pattern = NULL,
                            program_pattern = NULL) {
  df <- schedule

  if (!is.null(college_pattern)) {
    if ("COLLEGE" %in% names(df)) {
      df <- df %>% dplyr::filter(grepl(college_pattern, COLLEGE, ignore.case = TRUE))
    } else {
      warning("No 'COLLEGE' column found. College filter skipped.")
    }
  }

  if (!is.null(department_pattern)) {
    if ("DEPARTMENT" %in% names(df)) {
      df <- df %>% dplyr::filter(grepl(department_pattern, DEPARTMENT, ignore.case = TRUE))
    } else {
      warning("No 'DEPARTMENT' column found. Department filter skipped.")
    }
  }

  if (!is.null(program_pattern)) {
    if ("PROGRAM" %in% names(df)) {
      df <- df %>% dplyr::filter(grepl(program_pattern, PROGRAM, ignore.case = TRUE))
    } else {
      warning("No 'PROGRAM' column found. Program filter skipped.")
    }
  }

  if (!is.null(subject_pattern)) {
    if ("SUBJ" %in% names(df)) {
      df <- df %>% dplyr::filter(grepl(subject_pattern, SUBJ, ignore.case = TRUE))
    } else {
      warning("No 'SUBJ' column found. Subject filter skipped.")
    }
  }

  if (!is.null(instructor_pattern)) {
    if ("INSTRUCTOR" %in% names(df)) {
      df <- df %>% dplyr::filter(grepl(instructor_pattern, INSTRUCTOR, ignore.case = TRUE))
    } else {
      warning("No 'INSTRUCTOR' column found. Instructor filter skipped.")
    }
  }

  if (nrow(df) == 0) {
    warning("No records found after applying filters.")
  }

  return(df)
}
