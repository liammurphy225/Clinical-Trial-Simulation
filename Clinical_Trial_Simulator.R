

library(shiny)
library(shinythemes)
library(shiny)
library(ggplot2)
library(dplyr)
library(pwr)

# UI
ui <- fluidPage(
  titlePanel("Clinical Trial Simulator"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Trial Design Parameters"),
      #in parallel design we assume 1. independent samples, 2. between-group comparisons and 3. variance is determined by between-subject variability
      #parallel requires a larger sample size because  there's no within-subject control for variability
      #power is influenced by between-group variability, effect size and sample size
      
      #in crossover design we assume 1. within subject comparisons, 2. effects of treatment, period, and carryover must be accounted for and 3. reduced variability due to the use of paired data
      #requires  fewer participants due to reduced variability (within-subject variance is often smaller than between-subject variance)
      #power depend on the ability to isolate treatment effects from period and carryover effects
      #assumes no significant carryover effect(residual impact of treatment from a previous period that persists and influences other periods ex:if the same subject receives the multiple treatments in different periods)
      
       selectInput("design", "Trial Design:",
                  choices = c("Parallel" = "parallel", "Crossover" = "crossover")),
      #smaller effects require larger sample size 
      numericInput("effect_size", "Effect Size (Difference Between Groups):", value = 0.5, min = 0),
      #lower sd increase power
      numericInput("std_dev", "Standard Deviation:", value = 1, min = 0),
      #lowering the threshold will decrease the power ex: from 0.05 to 0.01
      numericInput("alpha", "Significance Level (α):", value = 0.05, min = 0.001, max = 0.1, step = 0.01),
      #power is calulated by 1 - beta(type II error or the probability of failing to reject the null hypothesis when the alternative is true)
      numericInput("power", "Power (1 - β):", value = 0.8, min = 0.5, max = 1, step = 0.05),
      
      numericInput("sample_size", "Sample Size (per group):", value = 50, min = 1),
      
      actionButton("simulate", "Simulate")
    ),
    
    mainPanel(
      h4("Simulation Results"),
      textOutput("sample_size_result"),
      plotOutput("power_curve")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Reactive function to calculate power or sample size
  calculate_power <- reactive({
    if (input$design == "parallel") {
      power_result <- pwr.t.test(d = input$effect_size / input$std_dev, 
                                 sig.level = input$alpha, 
                                 power = input$power, 
                                 type = "two.sample")
    } else {
      power_result <- pwr.t.test(d = input$effect_size / input$std_dev, 
                                 sig.level = input$alpha, 
                                 power = input$power, 
                                 type = "paired")
    }
    return(power_result)
  })
  
  # Text output for sample size result
  output$sample_size_result <- renderText({
    req(input$simulate)
    power_result <- calculate_power()
    paste("Required Sample Size (per group):", round(power_result$n))
  })
  
  # Power curve visualization
  output$power_curve <- renderPlot({
    req(input$simulate)
    effect_sizes <- seq(0.1, 1.5, by = 0.1)
    powers <- sapply(effect_sizes, function(es) {
      if (input$design == "parallel") {
        pwr.t.test(d = es / input$std_dev, sig.level = input$alpha, n = input$sample_size)$power
      } else {
        pwr.t.test(d = es / input$std_dev, sig.level = input$alpha, n = input$sample_size, type = "paired")$power
      }
    })
    
    data <- data.frame(EffectSize = effect_sizes, Power = powers)
    
    ggplot(data, aes(x = EffectSize, y = Power)) +
      geom_line(color = "blue") +
      geom_hline(yintercept = input$power, linetype = "dashed", color = "red") +
      theme_minimal() +
      labs(title = "Power Curve", x = "Effect Size", y = "Power")
  })
}

# Run the App
shinyApp(ui = ui, server = server)
