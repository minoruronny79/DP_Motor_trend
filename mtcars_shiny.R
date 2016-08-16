library(shiny)
library(ggplot2)
library(plotly)


#######################################################################
###############Exploring the data######################################
#######################################################################

#[, 1]	 mpg	 Miles/(US) gallon
#[, 2]	 cyl	 Number of cylinders
#[, 3]	 disp	 Displacement (cu.in.)
#[, 4]	 hp	 Gross horsepower
#[, 5]	 drat	 Rear axle ratio
#[, 6]	 wt	 Weight (1000 lbs)
#[, 7]	 qsec	 1/4 mile time
#[, 8]	 vs	 V/S
#[, 9]	 am	 Transmission (0 = automatic, 1 = manual)
#[,10]	 gear	 Number of forward gears
#[,11]	 carb	 Number of carburetors

##Some tables and graphics
mtcars<-mtcars
mtcars$models<-row.names(mtcars)
str(mtcars)
head(mtcars)


#######################################################################
############Creating the shiny application#############################
#######################################################################

ui<-fluidPage(
        mainPanel("Pick an option to analyze the dataset",
        tabsetPanel(
                #First tab panel
                tabPanel(
                        "One variable graphic",
                        selectInput("var1", "Select the variable", 
                                    choices = names(mtcars)),
                        plotlyOutput("una")
                        ),
                
                #Second tab panel
                tabPanel(
                        "Two variables graphics",
                        selectInput("var2", "Select the first variable", choices = names(mtcars)),
                        selectInput("var3", "Select the second variable", choices = names(mtcars)),
                        plotOutput("grafico")                
                ),
                
        
                #Third tab panel
                tabPanel(
                        "Summary",
                        checkboxGroupInput("variables", "Choice the variables", choices = names(mtcars)),
                        verbatimTextOutput("Summary")
                )
                )
        
        )
        
)



server<-function(input, output){
        ###########################################
        #About first tabset panel
        
        #Input variable
        onevariable<-reactive({
                mtcars[,c(input$var1)]
        })
        
        output$una<-renderPlotly({
                qplot(onevariable())
        })
        #############################################
        #About second tabset panel
        
        #Input variable
        selected<-reactive({
                mtcars[,c(input$var2, input$var3)]
        })
        
        #Graphic two variables
        output$grafico<-renderPlot({
                plot(selected())
        })
        
        #summary
        varsummary<-reactive({
                mtcars[,input$variables]
        })
        output$Summary<-renderPrint({
                summary(varsummary())
        })
}

shinyApp(server=server, ui=ui)

