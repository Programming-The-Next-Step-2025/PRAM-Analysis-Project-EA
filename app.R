# app.R
# -----------------------------
# This is the main UI/server script for the PRAManalysis Shiny app.
# It allows users to upload an Excel file and view a preview.
# file parsing is handled by `parse_uploaded_file() in R/data_io.R

#access helper functions from the appropriate script
source("data_io.R")


#define the user-interface
ui <- fluidPage(
  titlePanel("PRAMtable (Editable Table)"),
  fileInput("file1", "Upload Excel file here"),
  rHandsontableOutput("preview"),
  downloadButton("download_data", "Download Edited Excel")

)

#define server logic
server <- function(input, output, session) {
  state <- reactiveValues(
    data = NULL,
    label_choices = character(),
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
    rhandsontable(state$data, useTypes = TRUE, stretchH = "all") %>%
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

shinyApp(ui, server)


#launch the shiny app
shinyApp(ui, server)
