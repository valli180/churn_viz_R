library(dash)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)

app = Dash$new()
app$layout(htmlDiv('I am alive!!'))
app$run_server(debug = T)