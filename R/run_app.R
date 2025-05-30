#' Run the Shiny App
#'
#' @import shiny
#' @export
run_PRAM_table <- function() {
  shinyApp(ui= app_ui(), server = app_server)
}

