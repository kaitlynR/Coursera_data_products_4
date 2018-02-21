#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


library(shiny)
TreeData <- as.matrix(trees)


# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
        
        # Application title
        titlePanel("Tree Data"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        selectInput("variable", "Variable:",
                                    list("girth" = "Girth", 
                                         "height" = "Height", 
                                         "volume" = "Volume")),
                        
                        checkboxInput("outliers", "Show outliers", FALSE)
                ),
                
                # Show a plot of the generated distribution
                mainPanel(
                        
                        h3(textOutput("caption")),
                        
                        plotOutput("TreePlot")
                )
        )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
        # Compute the forumla text in a reactive expression since it is 
        # shared by the output$caption and output$mpgPlot expressions
        formulaText <- reactive({
                paste("TreeData ~", input$variable)
        })
        
        # Return the formula text for printing as a caption
        output$caption <- renderText({
                formulaText()
        })
        
        # Generate a plot of the requested variable against mpg and only 
        # include outliers if requested
        output$TreePlot <- renderPlot({
                boxplot(as.formula(formulaText()), 
                        data = TreeData,
                        outline = input$outliers)
        })
})

# Run the application 
shinyApp(ui = ui, server = server)