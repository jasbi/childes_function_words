library(shiny)
library(bslib)
library(childesr)
library(tidyverse)
library(ggplot2)
library(feather)
library(RColorBrewer)
library(purrr)
library(yaml)

source("docs/styling.R")    # colors, themes, styling helpers
source("docs/data.R")       # data loading and calculations
source("docs/literature.R") # literature YAML loading/processing
source("docs/plots.R")      # UI and server definitions (plots, tables)

shinyApp(ui = ui, server = server)

shiny::runApp("docs/dashboard.R")
