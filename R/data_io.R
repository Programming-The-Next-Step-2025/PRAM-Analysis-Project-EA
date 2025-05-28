#Description: a script for data input, output and parsing for the shiny app.

#'Parse uploaded Excel file
#'
#' @param file An input file for shiny
#' @return A data.frame
#' @export
#' @importFrom readxl read_excel
#' @importFrom tools file_ext
#' @importFrom shiny req
parse_uploaded_file <- function(file) {

  # Accept either a shiny file input (list with $datapath) or a file path string
  path <- if (is.list(file) && !is.null(file$datapath)) file$datapath else file

  ext <- tools::file_ext(path)
  if (ext %in% c("xls", "xlsx")) {
    df <- readxl::read_excel(path)
    return(df)

  } else {
    df <- readxl::read_excel(file$datapath)
    return(df)
 } else {
    stop("Unsupported file type")
  }
}


#' Prepare Data for Shiny app
#'
#' Takes the full data.frame and then subsets the 3 static columns and adds empty
#' columns for the new information.
#'
#' @param df a data.frame, the same one previously parsed
#' @return a data.frame with the first three columns intact and two empy columns
#' @export
prepare_shiny_data <- function(df){
  if(ncol(df)>= 3) {
    prepped_df <- df[, 1:3]
  }
  prepped_df$Standared_Node_names <- ""
  prepped_df$Switch <- FALSE

  return (prepped_df)
}

