# app.R
# -----------------------------
# This is the main UI/server script for the PRAManalysis Shiny app.
# It allows users to upload an Excel file and view a preview.
# file parsing is handled by `parse_uploaded_file() in R/data_io.R

#access helper functions from the appropriate script
source("data_io.R")

state <- reactiveValues(
  data = NULL,
)

#define the user-interface
ui <- fluidPage(
  fileInput("file1", "Upload Excel file here"),
  DTOutput("preview")
)
#define server logic
server <- function(input, output, session) {
  #once the file is uploaded, parse and prepare for display
  observeEvent(input$file1, {
    req(input$file1)
    df_full <- parse_uploaded_file(input$file1)
    state$data <- prepare_shiny_data(df_full)
  })

  #Render an editable table
  output$preview <- renderDT({
    req(state$data)
    datatable(
      state$data,
      editable = list(target = "cell", disable = list(columns = 0:3)), #stop edits of the first two columns
      )
  })
  #Record the edits being made and update the reactive data
  observeEvent(input$preview_cell_edit, {
    info <- input$preview_cell_edit
    r <- info$row
    c <- info$col + 1
    v <- info$value

    #only permit editing columns 4 and 5
    if (c %in% c(4,5)) {
      state$data[r,c] <- coerceValue(v, state$data[r,c])
    }
  })
}
#launch the shiny app
shinyApp(ui, server)
