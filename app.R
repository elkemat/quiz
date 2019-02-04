require(shiny)
require(dplyr)

# import data
header.names = c('age', 'workclass', 'fnlwgt', 'education', 'education.num',
                 'marital.status', 'occupation', 'relationship', 'race',
                 'sex', 'capital.gain', 'capital.loss', 'hours.per.week',
                 'native.country', 'salary.per.year')
col.classes = c('integer', 'factor', 'integer', 'factor',
                'integer', 'factor', 'factor', 'factor',
                'factor', 'factor', 'integer', 'integer', 
                'integer', 'factor', 'factor')
training.data = read.csv(url('http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data'),
                         sep = ',', header = FALSE, 
                         col.names = header.names,
                         na.strings = ' ?',
                         colClasses = col.classes)
training.data = training.data %>% 
  select(age, marital.status)

ui = fluidPage(
  titlePanel("Age Distribution by Marital Status"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "select.marital.status",
                  label = "Select maritial status:",
                  choices = levels(training.data$marital.status))
    ),
    mainPanel(
      plotOutput("densityPlot")
    )
  )
)

server = function(input, output) {

  # get input data and generate plot according to the input
  output$densityPlot = renderPlot({
  training.data = training.data %>% 
    filter(marital.status == input$select.marital.status)
  
  hist(x = training.data$age, 
       main = paste("Histogram of different ages for marital status", 
                    input$select.marital.status),
       xlab = "Age")
  })
  
}

shinyApp(ui = ui, server = server)