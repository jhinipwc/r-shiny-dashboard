# server.R — Reactive server logic
# Author: Priyanka Sinha

server <- function(input, output, session) {

  # ── Reactive filtered data ─────────────────────────────────
  filtered_data <- reactive({
    data <- df %>%
      filter(date >= input$date_range[1], date <= input$date_range[2])
    if (input$market_filter != "All") {
      data <- data %>% filter(market == input$market_filter)
    }
    data
  })

  kpis <- reactive({ calculate_kpis(filtered_data()) })

  # ── KPI Value Boxes ────────────────────────────────────────
  output$box_revenue <- renderValueBox({
    valueBox(
      value  = paste0("€", format(round(kpis()$total_revenue / 1e6, 1), big.mark = ",")),
      subtitle = "Total Revenue (M)",
      icon   = icon("euro-sign"),
      color  = "blue"
    )
  })

  output$box_bookings <- renderValueBox({
    valueBox(
      value    = format(kpis()$total_bookings, big.mark = ","),
      subtitle = "Total Bookings",
      icon     = icon("calendar-check"),
      color    = "green"
    )
  })

  output$box_adr <- renderValueBox({
    valueBox(
      value    = paste0("€", round(kpis()$avg_adr, 0)),
      subtitle = "Average Daily Rate",
      icon     = icon("bed"),
      color    = "yellow"
    )
  })

  output$box_daily_avg <- renderValueBox({
    valueBox(
      value    = paste0("€", format(round(kpis()$avg_daily_rev, 0), big.mark = ",")),
      subtitle = "Avg Daily Revenue",
      icon     = icon("chart-bar"),
      color    = "purple"
    )
  })

  # ── Revenue Chart ──────────────────────────────────────────
  output$revenue_chart <- renderPlotly({
    data <- filtered_data() %>%
      mutate(week = floor_date(date, "week")) %>%
      group_by(week) %>%
      summarise(revenue = sum(revenue), .groups = "drop")

    plot_ly(data, x = ~week, y = ~revenue, type = "scatter", mode = "lines",
            line = list(color = "#1f77b4", width = 2),
            fill = "tozeroy", fillcolor = "rgba(31,119,180,0.1)") %>%
      layout(xaxis = list(title = ""), yaxis = list(title = "Revenue (€)"),
             hovermode = "x unified")
  })

  # ── Market Pie ─────────────────────────────────────────────
  output$market_pie <- renderPlotly({
    data <- filtered_data() %>%
      group_by(market) %>%
      summarise(revenue = sum(revenue), .groups = "drop")

    plot_ly(data, labels = ~market, values = ~revenue, type = "pie",
            textinfo = "label+percent") %>%
      layout(showlegend = TRUE)
  })

  # ── ADR Chart ──────────────────────────────────────────────
  output$adr_chart <- renderPlotly({
    data <- filtered_data() %>%
      mutate(month = floor_date(date, "month")) %>%
      group_by(month) %>%
      summarise(adr = mean(adr), .groups = "drop")

    plot_ly(data, x = ~month, y = ~adr, type = "bar",
            marker = list(color = "#ff7f0e")) %>%
      layout(xaxis = list(title = ""), yaxis = list(title = "ADR (€)"))
  })

  # ── Bookings Chart ─────────────────────────────────────────
  output$bookings_chart <- renderPlotly({
    data <- filtered_data() %>%
      mutate(week = floor_date(date, "week")) %>%
      group_by(week) %>%
      summarise(bookings = sum(bookings), .groups = "drop")

    plot_ly(data, x = ~week, y = ~bookings, type = "scatter", mode = "lines+markers",
            line = list(color = "#2ca02c")) %>%
      layout(xaxis = list(title = ""), yaxis = list(title = "Bookings"))
  })

  # ── Segment Charts ─────────────────────────────────────────
  output$segment_revenue <- renderPlotly({
    data <- filtered_data() %>%
      group_by(segment) %>%
      summarise(revenue = sum(revenue), .groups = "drop") %>%
      arrange(desc(revenue))

    plot_ly(data, x = ~reorder(segment, revenue), y = ~revenue, type = "bar",
            marker = list(color = c("#1f77b4","#ff7f0e","#2ca02c","#d62728"))) %>%
      layout(xaxis = list(title = "Segment"), yaxis = list(title = "Revenue (€)"))
  })

  output$segment_bookings <- renderPlotly({
    data <- filtered_data() %>%
      group_by(segment) %>%
      summarise(bookings = sum(bookings), .groups = "drop")

    plot_ly(data, labels = ~segment, values = ~bookings, type = "pie") %>%
      layout(showlegend = TRUE)
  })

  output$segment_table <- renderDT({
    filtered_data() %>%
      group_by(segment) %>%
      summarise(
        Revenue   = paste0("€", format(round(sum(revenue)), big.mark = ",")),
        Bookings  = format(sum(bookings), big.mark = ","),
        Avg_ADR   = paste0("€", round(mean(adr), 0)),
        .groups   = "drop"
      ) %>%
      datatable(rownames = FALSE, options = list(pageLength = 10))
  })

  # ── Raw Data Table ─────────────────────────────────────────
  output$raw_table <- renderDT({
    datatable(filtered_data(), rownames = FALSE, filter = "top",
              options = list(pageLength = 15, scrollX = TRUE))
  })

  # ── Downloads ──────────────────────────────────────────────
  output$download_csv <- downloadHandler(
    filename = function() paste0("analytics_export_", Sys.Date(), ".csv"),
    content  = function(file) write.csv(filtered_data(), file, row.names = FALSE)
  )
}
