# global.R — shared libraries and data loading
# Author: Priyanka Sinha

library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(lubridate)
library(scales)

# ── Load sample data ──────────────────────────────────────────
load_data <- function() {
  set.seed(42)
  dates <- seq(as.Date("2023-01-01"), as.Date("2024-12-31"), by = "day")
  n <- length(dates)

  data.frame(
    date       = dates,
    revenue    = round(abs(rnorm(n, mean = 50000, sd = 8000)) + 
                   500 * sin(2 * pi * as.numeric(format(dates, "%j")) / 365), 0),
    bookings   = round(abs(rnorm(n, mean = 200, sd = 30)), 0),
    adr        = round(abs(rnorm(n, mean = 250, sd = 20)), 2),
    segment    = sample(c("Corporate", "Leisure", "Group", "Government"), n, replace = TRUE),
    market     = sample(c("DACH", "UK", "France", "Benelux"), n, replace = TRUE)
  )
}

df <- load_data()

# ── KPI calculation helper ─────────────────────────────────────
calculate_kpis <- function(data) {
  list(
    total_revenue  = sum(data$revenue, na.rm = TRUE),
    total_bookings = sum(data$bookings, na.rm = TRUE),
    avg_adr        = mean(data$adr, na.rm = TRUE),
    avg_daily_rev  = mean(data$revenue, na.rm = TRUE)
  )
}
