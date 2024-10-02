# library(qrcode)

# code <- qr_code("QR CODE")
# print(code)
# 
# plot(code)
# /c/Users/kogi/Documents/QRapp/QRcodeGenerator 
# shinylive::export("C:/Users/kogi/Documents/repos/QRcodeGenerator", "site")
# shinylive::export(appdir = "C:/Users/kogi/Documents/repos/QRcodeGenerator", destdir = "docs")
# library(curl)


# library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("link", "Enter link below. If the download link don't work (in Chrome/Edge), right click on them and open in new tab.", "www.fhi.no")
    ),
    mainPanel(
      plotOutput("tplot" ),
      downloadButton("save", "Download QR in pdf"),
      downloadButton("save2", "Download QR in png")
    )
  )
)

server <- function(input, output) {
  # if (identical(Sys.getenv("R_CONFIG_ACTIVE"), "shinyapps")) {
  #   chromote::set_default_chromote_object(
  #     chromote::Chromote$new(chromote::Chrome$new(
  #       args = c("--disable-gpu", 
  #                "--no-sandbox", 
  #                "--disable-dev-shm-usage", # required bc the target easily crashes
  #                c("--force-color-profile", "srgb"))
  #     ))
  #   )
  # }
  
  tplot <- reactive({
    qr <- qrcode::qr_code(input$link)
    plot(qr)
    
  })
  output$tplot <- renderPlot({
    tplot()
  })
  
  # downloadHandler contains 2 arguments as functions, namely filename, content
  output$save <- downloadHandler(
    filename =  function() {
      paste("qr.pdf")
    },
    # content is a function with argument file. content writes the plot to the device
    content = function(file) {
      pdf(file) # open the pdf device
      plot(qrcode::qr_code(input$link)) # draw the plot
      dev.off()  # turn the device off
    } 
  )
  output$save2 <- downloadHandler(
    filename =  function() {
      paste("qr.png")
    },
    # content is a function with argument file. content writes the plot to the device
    content = function(file) {
      png(file) # open the pdf device
      plot(qrcode::qr_code(input$link)) # draw the plot
      dev.off()  # turn the device off
    } 
  )
  # outputOptions(output, "save", suspendWhenHidden = FALSE)
}
shiny::shinyApp(ui, server)