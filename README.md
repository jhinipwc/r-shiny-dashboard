# R Shiny Analytics Dashboard

> Production-grade interactive analytics dashboard built with R Shiny — reactive server logic, dynamic ggplot2/Plotly visualisations, and automated R Markdown reporting.

## Overview

A fully functional R Shiny application demonstrating enterprise-grade dashboard development: multi-tab layout, reactive filtering, real-time KPI cards, time-series charts, and automated PDF/HTML report generation via R Markdown. Built to the governance and documentation standards applied during ECB consulting work.

## Tech Stack
`R` `R Shiny` `ggplot2` `Plotly` `R Markdown` `PostgreSQL` `dplyr` `tidyr`

## Project Structure
```
r-shiny-dashboard/
├── app/
│   ├── ui.R
│   ├── server.R
│   ├── global.R
│   └── modules/
│       ├── kpi_cards.R
│       ├── time_series_module.R
│       ├── segment_module.R
│       └── report_module.R
├── reports/
│   └── monthly_report.Rmd
├── data/
│   └── sample_data.csv
├── tests/
│   └── test_modules.R
├── renv.lock
└── README.md
```

## Quick Start
```r
# Install dependencies
install.packages(c("shiny", "ggplot2", "plotly", "dplyr", "tidyr", "rmarkdown"))

# Run the app
shiny::runApp("app/")
```

## Key Features
- **KPI cards** — real-time metric summaries with trend indicators
- **Time-series charts** — interactive Plotly charts with date range filtering
- **Segmentation view** — customer segment breakdown with drill-down capability
- **Automated reports** — one-click R Markdown PDF/HTML report generation
- **PostgreSQL integration** — live data connection with optimised queries
- **Responsive layout** — works across desktop and tablet screen sizes

## Dashboard Preview
```
┌─────────────────────────────────────────────┐
│  KPI Cards: Revenue | Users | Conversion    │
├────────────────┬────────────────────────────┤
│ Time Series    │ Segment Distribution       │
│ (interactive)  │ (pie/bar toggle)           │
├────────────────┴────────────────────────────┤
│ Data Table (filterable, exportable)         │
└─────────────────────────────────────────────┘
```

---
**Priyanka Sinha** | [LinkedIn](https://linkedin.com/in/priyanka-sinha) | [Email](mailto:priyankasinhabhu@gmail.com)
