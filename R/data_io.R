#Description: a scrip for data input, output and parsing for the shiny app.

#'Parse uploaded Excel file
#'
#' @param file An input file for shiny
#' @return A data.frame
#' @export
parse_uploaded_file <- function(file) {
  req(file)
  ext <- tools::file_ext(file$datapath)
  if (ext %in% c("xls", "xlsx")) {
    readxl::read_excel(file$datapath)
  } else {
    stop("Unsupported file type")
  }
}

