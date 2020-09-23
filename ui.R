# This shiny app is used to predict the mpg of a car given a realistic weight, cylinders, transmission type and the
# time required to the car to cover 1/4 of a mile.

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Mileage per galon prediction"),

    # Sidebar with a slider input for features
    sidebarLayout(
        sidebarPanel(
            h3("About this app:"),
            "This app compares the prediction mileage per gallon (mpg) of four linear models.",
            "The models differ by the number of features used to predict mpg:", 
            "- only car weight (wt),
            - wt + time required to cover 1/4 of a mile (qsec),
            - Wt + qsec + number of cylinders (cyl),
            - wt + qsec + cyl + type of transmission (am)",
            h3("How to use this app:"),
            "Play around with the input data (wt, qsec, cyl, am) on the sliders below and automatically verify the prediction output of the models in the graph to the right and the numerical values below the slider. Verify if you can approximate the colours to the observed data according tho the real features of the points!",
            h3("Input data"),
                        sliderInput("n.weight",
                        "Choose car's weight (wt)",
                        min = 1.5,
                        max = 5.5,
                        value = 2,
                        step = 0.1),
            sliderInput("n.qsec",
                        "Choose required time to cover 1/4 of a mile (qsec)",
                        min = 14,
                        max = 24,
                        value = 19,
                        step = 0.02),
            sliderInput("n.cyl",
                        "Choose number of cylinders (cyl)",
                        min = 4,
                        max = 8,
                        value = 6,
                        step = 2),
            sliderInput("n.am",
                        "Choose transmission type (am, 1 for automatic, 0 for manual)",
                        min = 0,
                        max = 1,
                        value = 0,
                        step = 1),
            
            h3("Model predictions"),
            "Predicted MPG from Model 1", 
             textOutput("pred1"),
            "",
            "Predicted MPG from Model 2", 
            textOutput("pred2"),
            "",
            "Predicted MPG from Model 3", 
            textOutput("pred3"),
            "",
            "Predicted MPG from Model 4", 
            textOutput("pred4")

            
        ),
        


        # Show a plot of fitted models and predictions
        mainPanel(
            plotOutput("plot1")
            )
            
    )
)
)
