#Description: a script for data input, output and parsing for the shiny app.

#' Parse uploaded file (.csv or .xlsx)
#'
#' @param file A shiny file input (list) or path string
#' @return A data.frame
#' @importFrom readxl read_excel
#' @importFrom tools file_ext
#' @importFrom readr read_csv
#' @export
parse_uploaded_file <- function(file) {
  path <- if (is.list(file) && !is.null(file$datapath)) file$datapath else file
  ext <- tolower(file_ext(path))

  if (ext %in% c("xls", "xlsx")) {
    return(read_excel(path))
  } else if (ext == "csv") {
    return(read_csv(path, show_col_types = FALSE))
  } else {
    stop("Unsupported file type. Please upload a .csv, .xls, or .xlsx file.")
  }
}


#' Prepare Data for Shiny app
#'
#' Takes the full data.frame and then subsets the 3 static columns and adds empty
#' columns for the new information.
#'
#' @param df a data.frame, the same one previously parsed
#' @return a data.frame with the any existing columns intact and two added columns
#' @export
prepare_shiny_data <- function(df) {
  colnames(df) <- trimws(colnames(df))
  names(df) <- gsub("\\s+", "_", names(df))

  # Add Standared_Node_names if missing
  if (!"Standared_Node_names" %in% names(df)) {
    df$Standared_Node_names <- ""
  }
  # Add Switch column if missing
  if (!"Switch" %in% names(df)) {
    df$Switch <- FALSE
  }
  # Add categories column if missing — default empty string or could be NA
  if (!"Categories" %in% names(df)) {
    df$Categories <- ""
  }
  # Add switch_category column if missing — default FALSE logical
  if (!"Switch_Category" %in% names(df)) {
    df$Switch_Category <- FALSE
  }
  return(df)
}

#' function that wraps loading and parsing to clean the server script
#'
#' @param file a file path or shiny input list
#' @return prepared data.fram
#' @export
load_and_prepare_data <- function(file) {
  df <- parse_uploaded_file(file)
  prepare_shiny_data(df)
}

#' Get unique choices from a vector input
#'
#' @param vec a vector of characters
#' @return sorted unique vector with no empty strings
#' @export
get_unique_choices <- function(vec) {
  choices <- unique(trimws(vec))
  choices <- choices[choices != ""]
  sort(choices)
}

#' Update reactive choices in state from a data frame
#'
#' @param state reactiveValues object containing label_choices and category_choices
#' @param df data.frame with Standared_Node_names and categories columns
#' @export
update_choices <- function(state, df) {
  state$label_choices <- unique(c(state$label_choices, df$Standared_Node_names))
  state$label_choices <- get_unique_choices(state$label_choices)
  state$category_choices <- unique(c(state$category_choices, df$Categories))
  state$category_choices <- get_unique_choices(state$category_choices)
}
