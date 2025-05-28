#' App UI for PRAMtable
#'
#' @return Shiny UI object
#' @import shiny
#' @import rhandsontable
#' @import visNetwork
#' @export

app_ui <- function(){
  fluidPage(
    titlePanel("PRAMtable (an editable table)"),
    fileInput("file1", "Upload Excel file here"),
    actionButton("load_example", "Or click here to load example data"),
    rHandsontableOutput("preview"),
    visNetworkOutput("graph", height = "600px"),
    downloadButton("download_data", "Download Edited Excel")
  )
}

