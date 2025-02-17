# library(qrcode)

# code <- qr_code("QR CODE")
# print(code)
# 
# plot(code)
# /c/Users/kogi/Documents/QRapp/QRcodeGenerator 
# shinylive::export("C:/Users/kogi/Documents/repos/QRcodeGenerator", "site")
# shinylive::export(appdir = "C:/Users/kogi/Documents/repos/QRapps/QRcodeGenerator", destdir = "docs")
# library(curl)


# library(shiny)
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}



ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("link", "Enter link below", "www.fhi.no"),      plotOutput("tplot" ),
      downloadButton("downloadData", "Download in pdf"),
      downloadButton("downloadData4", "Download in svg"),
      downloadButton("downloadData2", "Download in png")
      # downloadButton("downloadData3", "Download in png (high redudancy)")
    ),
    mainPanel(

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
    qr <- qrcode::qr_code(input$link,ecl="M")
    plot(qr)
    
  })
  output$tplot <- renderPlot({
    tplot()
  })
  
  output$downloadData <- downloadHandler(
    filename = "qrfile.pdf",
    content = function(file) {
      pdf(file) # open the pdf device
      plot(qrcode::qr_code(input$link,ecl="M")) # draw the plot
      dev.off()  # turn the device off
    }
  )
  
  output$downloadData2 <- downloadHandler(
    filename = "qrfile.png",
    content = function(file) {
      png(file) # open the pdf device
      plot(qrcode::qr_code(input$link,ecl="M")) # draw the plot
      dev.off()  # turn the device off
    }
  )
  
  output$downloadData4 <- downloadHandler(
    filename = "qrfile.svg",
    content = function(file) {
      svg(file) # open the pdf device
      plot(qrcode::qr_code(input$link,ecl="M")) # draw the plot
      dev.off()  # turn the device off
    }
  )
  
  output$downloadData3 <- downloadHandler(
    filename = "qrfile.png",
    content = function(file) {
      png(file) # open the pdf device
      plot(qrcode::qr_code(input$link,ecl="H")) # draw the plot
      dev.off()  # turn the device off
    }
  )
  # outputOptions(output, "save", suspendWhenHidden = FALSE)
}
shiny::shinyApp(ui, server)