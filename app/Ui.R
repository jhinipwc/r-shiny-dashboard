# ui.R — Dashboard layout and UI components
# Author: Priyanka Sinha

ui <- dashboardPage(
  skin = "blue",

  dashboardHeader(title = "Analytics Dashboard"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview",     tabName = "overview",     icon = icon("chart-line")),
      menuItem("Segmentation", tabName = "segmentation", icon = icon("users")),
      menuItem("Data Table",   tabName = "table",        icon = icon("table")),
      menuItem("Report",       tabName = "report",       icon = icon("file-alt"))
    ),
    hr(),
    dateRangeInput("date_range", "Date Range:",
      start = Sys.Date() - 365,
      end   = Sys.Date(),
      min   = "2023-01-01",
      max   = "2024-12-31"
    ),
    selectInput("market_filter", "Market:",
      choices  = c("All", "DACH", "UK", "France", "Benelux"),
      selected = "All"
    )
  ),

  dashboardBody(
    tabItems(

      # ── Overview Tab ───────────────────────────────────────
      tabItem(tabName = "overview",
        fluidRow(
          valueBoxOutput("box_revenue",   width = 3),
          valueBoxOutput("box_bookings",  width = 3),
          valueBoxOutput("box_adr",       width = 3),
          valueBoxOutput("box_daily_avg", width = 3)
        ),
        fluidRow(
          box(title = "Revenue Over Time", width = 8, status = "primary",
              plotlyOutput("revenue_chart", height = 300)),
          box(title = "Market Mix", width = 4, status = "info",
              plotlyOutput("market_pie", height = 300))
        ),
        fluidRow(
          box(title = "ADR Trend", width = 6, status = "warning",
              plotlyOutput("adr_chart", height = 250)),
          box(title = "Bookings Trend", width = 6, status = "success",
              plotlyOutput("bookings_chart", height = 250))
        )
      ),

      # ── Segmentation Tab ───────────────────────────────────
      tabItem(tabName = "segmentation",
        fluidRow(
          box(title = "Revenue by Segment", width = 6, status = "primary",
              plotlyOutput("segment_revenue", height = 350)),
          box(title = "Bookings by Segment", width = 6, status = "info",
              plotlyOutput("segment_bookings", height = 350))
        ),
        fluidRow(
          box(title = "Segment Performance Table", width = 12,
              DTOutput("segment_table"))
        )
      ),

      # ── Data Table Tab ─────────────────────────────────────
      tabItem(tabName = "table",
        fluidRow(
          box(title = "Raw Data", width = 12,
              DTOutput("raw_table"))
        )
      ),

      # ── Report Tab ─────────────────────────────────────────
      tabItem(tabName = "report",
        fluidRow(
          box(title = "Generate Report", width = 4, status = "primary",
              p("Generate a downloadable analytics report for the selected date range."),
              br(),
              downloadButton("download_report", "Download PDF Report", class = "btn-primary"),
              br(), br(),
              downloadButton("download_csv", "Download Data (CSV)", class = "btn-default")
          )
        )
      )
    )
  )
)
