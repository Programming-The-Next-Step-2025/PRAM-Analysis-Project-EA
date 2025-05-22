# app.R
# -----------------------------
# This is the main UI/server script for the PRAManalysis Shiny app.
# It allows users to upload an Excel file and view a preview.
# file parsing is handled by `parse_uploaded_file() in R/data_io.R

#define the user-interface
ui <- fluidPage(
  fileInput("file1", "Upload Excel file here"),
  tableOutput("preview")
)
#define server logic
server <- function(input, output, session) {
  data <- reactive({
    parse_uploaded_file(input$file1)
  })
  #display a preview of the table
  output$preview <- renderTable({
    head(data())
  })
}
#launch the shiny app
shinyApp(ui, server)
