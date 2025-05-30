#' App Server for PRAMtable
#'
#' @param input Shiny input
#' @param output Shiny output
#' @param session Shiny session
#' @import shiny
#' @importFrom shinyjs enable disable
#' @import rhandsontable
#' @import visNetwork
#' @importFrom writexl write_xlsx
#' @export
app_server <-  function (input, output, sessionInfo){
  state <- reactiveValues(
    data = NULL,
    label_choices = character(),
    category_choices = character()
  )
  #reset the inputs if the app tries to load more than one file at once
  observeEvent(input$reset_inputs, {
    enable("file1")
    enable("load_example")
    state$data <- NULL
    state$label_choices <- character()
    state$category_choices <- character()
  })

  # Load example Excel file when button is clicked
  observeEvent(input$load_example, {
    example_path <- "www/Unlabeled_Excel_Sheet.xlsx"
    df <- load_and_prepare_data(example_path)
    state$data <- df
    update_choices(state, df)
  })


  #once the file is uploaded, parse and prepare for display
  observeEvent(input$file1, {
    req(input$file1)
    df <- load_and_prepare_data(input$file1)
    state$data <- df
    update_choices(state, df)
  })

  # Render editable rhandsontable
  output$preview <- renderRHandsontable({
    req(state$data)
    rhandsontable(state$data, useTypes = TRUE, stretchH = "all") %>%

      #first new column has a dropdown list which updates as you edit the sheet
      hot_col("Standared_Node_names", type = "autocomplete",
              source = state$label_choices, allowInvalid = TRUE) %>%

      #second new column is a checkbox
      hot_col("Switch", type = "checkbox") %>%

      #third new column has a dropdown list which updates as you edit the sheet
      hot_col("Categories", type = "autocomplete",
              source = state$category_choices, allowInvalid = TRUE) %>%

      #fourth new column is a checkbox
      hot_col("Switch_Category", type = "checkbox") %>%

      #highlight where the user is editingfor clarity
      hot_table(highlightCol = TRUE, highlightRow = TRUE)
  })

  # Track changes and update reactive data
  observeEvent(input$preview, {
    updated <- hot_to_r(input$preview)

    # Ensure checkbox columns are logical
    for (col in c("Switch", "Switch_Category")) {
      if (col %in% names(updated)) {
        updated[[col]] <- as.logical(updated[[col]])
      }
    }

    state$data <- updated

    # Use your helper to update choices
    update_choices(state, updated)
  })

  # Render dynamic graph based on dropdown choices
  output$graph <- renderVisNetwork({
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

    # No edges, just nodes
    visNetwork(nodes, data.frame()) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visPhysics(enabled = FALSE) %>%  # allow free dragging
      visInteraction(dragNodes = TRUE, zoomView = TRUE) %>%
      visLayout(improvedLayout = FALSE)  # consistent layout
  })

  # Download handler to save the edited data as Excel
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("edited_data_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      req(state$data)
      write_xlsx(state$data, path = file)
    }
  )
}
