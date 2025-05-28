#' App Server for PRAMtable
#'
#' @param input Shiny input
#' @param output Shiny output
#' @param session Shiny session
#' @import shiny
#' @import rhandsontable
#' @import visNetwork
#' @importFrom writexl write_xlsx
#' @export

app_server <-  function (input, output, sessionInfo){
  state <- reactiveValues(
    data = NULL,
    label_choices = character()
  )

  #once the file is uploaded, parse and prepare for display
  observeEvent(input$file1, {
    req(input$file1)
    df_full <- parse_uploaded_file(input$file1)
    prepped <- prepare_shiny_data(df_full)
    state$data <- prepped
    state$label_choices <- unique(prepped$Standared_Node_names)
  })

  # Render editable rhandsontable
  output$preview <- renderRHandsontable({
    req(state$data)
    rhandsontable::rhandsontable(state$data, useTypes = TRUE, stretchH = "all") %>%
      hot_col("Standared_Node_names", type = "autocomplete",
              source = state$label_choices, allowInvalid = TRUE) %>%
      hot_col("Switch", type = "checkbox") %>%
      hot_table(highlightCol = TRUE, highlightRow = TRUE)
  })

  # Track changes and update reactive data
  observeEvent(input$preview, {
    updated <- hot_to_r(input$preview)
    if ("Switch" %in% colnames(updated)) {
      updated$Switch <- as.logical(updated$Switch)
    }
    state$data <- updated
    state$label_choices <- unique(c(state$label_choices, updated$Standared_Node_names))
  })

  # Render dynamic graph based on dropdown choices
  output$graph <- visNetwork::renderVisNetwork({
    req(state$data)

    # Get unique non-empty dropdown values
    node_names <- unique(trimws(state$data$Standared_Node_names))
    node_names <- node_names[node_names != ""]

    if (length(node_names) == 0) return(NULL)

    nodes <- data.frame(
      id = node_names,
      label = node_names,
      stringsAsFactors = FALSE
    )

    # No edges — just nodes
    visNetwork::visNetwork(nodes, data.frame()) %>%
      visNetwork::visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visNetwork::visPhysics(enabled = FALSE) %>%  # allow dragging
      visNetwork::visInteraction(dragNodes = TRUE, zoomView = TRUE) %>%
      visNetwork::visLayout(improvedLayout = FALSE)  # consistent layout
  })

  # Download handler to save the edited data as Excel
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("edited_data_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      req(state$data)
      writexl::write_xlsx(state$data, path = file)
    }
  )
}
