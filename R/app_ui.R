#' App UI for PRAMtable
#'
#' @return Shiny UI object
#' @import shiny
#' @importFrom shinyjs enable disable
#' @import rhandsontable
#' @import visNetwork
#' @export
app_ui <- function(){
  fluidPage(
    titlePanel("PRAMtable (an editable table)"),

    fileInput("file1", "Upload .xls, .xlxs, or .csv file here"),

    actionButton("load_example", "Or click here to load example data"),

    actionButton("reset_inputs", "Reset Input Options"),

    rHandsontableOutput("preview"),

    visNetworkOutput("graph", height = "1000px"),

    downloadButton("download_data", "Download Edited Table")
  )
}
