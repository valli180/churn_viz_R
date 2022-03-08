library(dash)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(purrr)


df = read.csv("data/customer_churn.csv")
numerical_features_to_analyze = c('Account_Length', 'Vmail_Message', 'Day_Mins', 'Eve_Mins',
                                  'Night_Mins', 'Intl_Mins', 'CustServ_Calls', 'Day_Calls', 'Day_Charge',
                                  'Eve_Calls', 'Eve_Charge', 'Night_Calls', 'Night_Charge', 'Intl_Calls',
                                  'Intl_Charge', 'Churn')
df_new <- df %>%
  select(numerical_features_to_analyze)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
  dbcContainer(
    list(
      dccGraph(id='plot-area'),
      dccDropdown(
        id='col-select',
        options = df_new %>%
          colnames() %>%
          purrr::map(function(col) list(label = col, value = col)),
        value='Account_Length')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('col-select', 'value')),
  function(xcol) {
    p <- ggplot(df_new, aes(x = !!sym(xcol),
                            y = Churn,
                            color = Churn)) +
      geom_point() +
      scale_x_log10() +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)

app$run_server(debug = T)
