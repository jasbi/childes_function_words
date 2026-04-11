library(shiny)
library(bslib)
library(childesr)
library(tidyverse)
library(ggplot2)
library(feather)
library(RColorBrewer)
library(purrr)
library(yaml)

source("dashboard/styling.R")    # colors, themes, styling helpers
source("dashboard/data.R")       # data loading and calculations
source("dashboard/literature.R") # literature YAML loading/processing
source("dashboard/plots.R")      # UI and server definitions (plots, tables)

shinyApp(ui = ui, server = server)

shiny::runApp("dashboard/dashboard.R")