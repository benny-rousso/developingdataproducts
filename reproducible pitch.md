Developing data products - Benny Zuse Rousso

<style>
.small-code pre code {
  font-size: 1em;
}
</style>

Course Project Week 4
========================================================
author: Benny Zuse Rousso
date: 23/09/2020
autosize: true

Background
========================================================

Fuel consumption is one of the key elements when choosing a car. Have you ever wondered if it would be possible to predict how many miles per gallon (mpg) a car could do? This presentation is about an app that allows you to predict the mpg of a car by determining its weight (wt), time required to cover 1/4 of a mile (qsec), number of cylinders (cyl) and type of transmission (am).

Additionally, you can visually compare how accurate the prediction would be if you consider only some of all of these features. By defining different scenarios, you can infer if the model is accurate or how a not existing car would theoretically perform, based on these features! 


Documentation
========================================================
This app compares the prediction mileage per gallon (mpg) of four linear models.

The models differ by the number of features used to predict mpg:", 
 - only car weight (wt),
 - wt + time required to cover 1/4 of a mile (qsec),
 - Wt + qsec + number of cylinders (cyl),
 - wt + qsec + cyl + type of transmission (am)",
 
How to use the app:
Play around with the input data (wt, qsec, cyl, am) on the sliders  and automatically verify the prediction output of the models in the graph and the prediction values below the slider.


Methods
========================================================
class:small-code
The app was developed using the `Shiny` package in Rstudio.

Calculations were performed on the `mtcars` database and models were fitted using the `lm` function.

Below, a glimpse of the `mtcars` database is shown

```r
head(mtcars)
```

```
                   mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

Shiny app server structure
========================================================
class:small-code
Below, a sample of the structure of the Shiny app server where the reactive process and plotting generation occurs


```r
# Define server logic
shinyServer(function(input, output) {
   
    # Create fitting models
    fit1 <- lm(mpg~wt,data=mtcars) [# repeated for other fits...]

    # Calculate predictions for each fit
        # Fit 1
    fit1pred <- reactive({
        wtInput <- input$n.weight
        predict(fit1,newdata = data.frame(wt=wtInput)) [# repeated for other fits...]
    })
```


```r
# Produce plot from input data
wtInput <- input$n.weight #Refer to previous code chunk
colors <- c(wt = red, wt+qsec = blue, wt+qsec+cyl=green, wt+qsec+cyl+am = purple ) # vector with colors for aesthetic
  
output$plot1 <- renderPlot({
        ggplot(mtcars, aes(x=wt, y=mpg))+geom_point(size=3,alpha=0.4) +                   #plotting observed data
            
            geom_line(data=fortify(fit1), aes(x=wt,y=.fitted, colour = "wt"),size=1, alpha = 0.4) +      #fitted models
            geom_line(data=fortify(fit2), aes(x=wt,y=.fitted, colour = "wt+qsec"),size=1, alpha = 0.4) +
            geom_line(data=fortify(fit3), aes(x=wt,y=.fitted, colour = "wt+qsec+cyl"),size=1, alpha = 0.4) +
            geom_line(data=fortify(fit4), aes(x=wt,y=.fitted, colour = "wt+qsec+cyl+am"),size=1, alpha = 0.4) +
            
            geom_point(aes(x=wtInput, y=fit1pred()), colour="red", size = 4,alpha=0.6)+  #plotting points inputted by user       
            geom_point(aes(x=wtInput, y=fit2pred()), colour="blue", size = 4,alpha=0.6)+
            geom_point(aes(x=wtInput, y=fit3pred()), colour="green", size = 4,alpha=0.6)+
            geom_point(aes(x=wtInput, y=fit4pred()), colour="purple", size = 4,alpha=0.6)+
            
            facet_grid(am~cyl, labeller = label_both) +                                 # graph aesthetics
            labs(x="Weight (tons)", y="Mileage per gallon (mpg)", colour = "") +
            scale_colour_manual(values=colors) + theme_bw() + 
            theme(legend.position = "bottom", text = element_text(size=15)) 
    }
```
