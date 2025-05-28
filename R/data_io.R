#Description: a scrip for data input, output and parsing for the shiny app.

#'Parse uploaded Excel file
#'
#' @param file An input file for shiny
#' @return A data.frame
#' @export
parse_uploaded_file <- function(file) {
<<<<<<< Updated upstream
  req(file)
  ext <- tools::file_ext(file$datapath)
  if (ext %in% c("xls", "xlsx")) {
    readxl::read_excel(file$datapath)
=======
  # Accept either a shiny file input (list with $datapath) or a file path string
  path <- if (is.list(file) && !is.null(file$datapath)) file$datapath else file

  ext <- tools::file_ext(path)
  if (ext %in% c("xls", "xlsx")) {
    df <- readxl::read_excel(path)
    return(df)
>>>>>>> Stashed changes
  } else {
    stop("Unsupported file type")
  }
}

