#' App UI for PRAMtable
#'
#' @return Shiny UI object
#' @import shiny
#' @import rhandsontable
#' @import visNetwork
#' @export

app_ui <- function(){
  fluidPage(
    titlePanel("PRAMtable (Editable Table)"),
    fileInput("file1", "Upload Excel file here"),
    rHandsontableOutput("preview"),
    visNetworkOutput("graph", height = "600px"),
    downloadButton("download_data", "Download Edited Excel")
  )
}
