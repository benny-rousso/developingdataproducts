# This is the server logic of a Shiny web application to predict the mpg of a car given a realistic weight, cylinders, 
# transmission type and the time required to the car to cover 1/4 of a mile (qsec).

library(shiny)
library(ggplot2)
# Define server logic
shinyServer(function(input, output) {
   
    # Create fitting models
    fit1 <- lm(mpg~wt,data=mtcars)
    fit2 <- lm(mpg~wt+qsec,data=mtcars)
    fit3 <- lm(mpg~wt+qsec+cyl,data=mtcars)
    fit4 <- lm(mpg~wt+qsec+am,data=mtcars)
    
    # Calculate predictions for each fit
        # Fit 1
    fit1pred <- reactive({
        wtInput <- input$n.weight
        predict(fit1,newdata = data.frame(wt=wtInput))
    })
        #Fit 2
    fit2pred <- reactive({
        wtInput <- input$n.weight
        qsecInput <- input$n.qsec
        predict(fit2,newdata = data.frame(wt=wtInput, qsec=qsecInput))
    })
        #Fit 3
    fit3pred <- reactive({
        wtInput <- input$n.weight
        qsecInput <- input$n.qsec
        cylInput <- input$n.cyl
        predict(fit3,newdata = data.frame(wt=wtInput, qsec=qsecInput, cyl=cylInput))
    })
        #Fit 4
    fit4pred <- reactive({
        wtInput <- input$n.weight
        qsecInput <- input$n.qsec
        cylInput <- input$n.cyl
        amInput <- input$n.am
        predict(fit4,newdata = data.frame(wt=wtInput, qsec=qsecInput, cyl=cylInput, am=amInput))
    })

    # Producte plot from input data
    output$plot1 <- renderPlot({
        
        colors <- c("wt" = "red","wt+qsec" = "blue", "wt+qsec+cyl"="green", "wt+qsec+cyl+am" = "purple" )
        wtInput <- input$n.weight

        
        ggplot(mtcars, aes(x=wt, y=mpg))+geom_point(size=3,alpha=0.4) + theme_bw() + 
            theme(legend.position = "bottom",
                  text = element_text(size=15)) +
            
            
            geom_line(data=fortify(fit1), aes(x=wt,y=.fitted, colour = "wt"),size=1, alpha = 0.4) +
            geom_line(data=fortify(fit2), aes(x=wt,y=.fitted, colour = "wt+qsec"),size=1, alpha = 0.4) +
            geom_line(data=fortify(fit3), aes(x=wt,y=.fitted, colour = "wt+qsec+cyl"),size=1, alpha = 0.4) +
            geom_line(data=fortify(fit4), aes(x=wt,y=.fitted, colour = "wt+qsec+cyl+am"),size=1, alpha = 0.4) +
            
            geom_point(aes(x=wtInput, y=fit1pred()), colour="red", size = 4,alpha=0.6)+
            geom_point(aes(x=wtInput, y=fit2pred()), colour="blue", size = 4,alpha=0.6)+
            geom_point(aes(x=wtInput, y=fit3pred()), colour="green", size = 4,alpha=0.6)+
            geom_point(aes(x=wtInput, y=fit4pred()), colour="purple", size = 4,alpha=0.6)+
            
            facet_grid(am~cyl, labeller = label_both) +
            labs(x="Weight (tons)", y="Mileage per gallon (mpg)", colour = "") +
            scale_colour_manual(values=colors)
            
            
    },height=900)

    output$pred1 <- renderText({
        fit1pred()
    })
    output$pred2 <- renderText({
        fit2pred()
    })
    output$pred3 <- renderText({
        fit3pred()
    })
    output$pred4 <- renderText({
        fit4pred()
    })    
    
})

