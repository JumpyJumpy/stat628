library("shiny")
library("ggplot2")

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  sidebarPanel(
    titlePanel("Body Fat Calculator"),
    
    
    numericInput("height", label = h4("Height (cm)"), value = ""),
    #numericInput("weight", label = h4("Weight (kg)"), value = ""),
    numericInput("wrist", label = h4("Wrist (cm)"), value = ""),
    #numericInput("age", label = h4("Age"), value = ""),
    numericInput("abdomen", label = h4("Abdomen (cm)"), value = ""),
    
    actionButton("calculate", label = h4("Calculate"))
  ),
  mainPanel(h2(verbatimTextOutput("bodyfat")),
            plotOutput("densityPlot"))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  BodyFat_cleaned <- read.csv("./BodyFat_cleaned.csv", encoding = "UTF-8")
  final <- lm(BODYFAT ~ HEIGHT + ABDOMEN + WRIST, data = BodyFat_cleaned)
    
  
  bodyfat <- eventReactive(input$calculate, {
    predict(final,
            newdata = data.frame(
              HEIGHT = input$height,
              ABDOMEN = input$abdomen,
              WRIST = input$wrist
            ))
  })
  output$bodyfat <- renderText({
    bodyfat()
  })
  
  dens <- observeEvent(input$calculate, {
    output$densityPlot <- renderPlot({
      plot(density(BodyFat_cleaned$BODYFAT))
      points(x = predict(final,
      newdata = data.frame(
        HEIGHT = input$height,
        ABDOMEN = input$abdomen,
        WRIST = input$wrist
      )), y = 0, col = "red", pch = 1)
    })
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
