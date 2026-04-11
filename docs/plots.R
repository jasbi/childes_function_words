ui <- fluidPage(
  title = "Function Word Acquisition Trajectories",
  theme = aggie_theme,
  tags$head(
    tags$style(HTML(sprintf(
      "
      .navbar, .panel-title {
        background-color: %s !important;
        color: %s !important;
      }
      h1, h2, h3, h4, .control-label, label {
        color: %s !important;
      }
      .well, .card {
        background-color: %s !important;
        border-color: %s !important;
      }
      /* App title styling */
      .app-title {
        text-align: center;
        margin: 15px 0 5px 0;
        font-family: 'Lato', sans-serif;
        font-weight: 700;
        font-size: 26px;
        color: %s;
      }
      .app-title-highlight {
        color: %s;
      }
      /* Navbar tab styling */
      .navbar-nav > li > a {
        font-weight: 600;
        font-size: 14px;
        padding: 12px 24px;
      }
      .navbar-nav > li.active > a,
      .navbar-nav > li.active > a:focus,
      .navbar-nav > li.active > a:hover {
        background-color: %s !important;
        color: %s !important;
      }
      .navbar-nav > li > a:hover {
        background-color: %s !important;
        color: %s !important;
      }
      ",
      aggie_blue, aggie_gold, aggie_blue, aggie_gold, aggie_blue,
      aggie_blue, aggie_gold,
      aggie_gold, aggie_blue,
      "#e6e6e6", aggie_blue
    )))
  ),
  titlePanel(
    div(
      class = "app-title",
      HTML(
        sprintf(
          "Function Word Acquisition Trajectories"
        )
      )
    )
  ),
  navbarPage(
    title = NULL,
    theme = NULL,
    tabPanel(
      title = HTML(sprintf('<span style="color:%s;font-weight:bold;">Function Word Trajectories</span>', aggie_gold)),
      sidebarLayout(
        sidebarPanel(
          tags$h3("Function Word Trajectories"),
          selectInput(
            "traj_view",
            "View",
            choices = c(
              "Function Word Trajectories" = "trajectories",
              "Population Trajectories" = "population_trajectories",
              "Function Word Growth Curves" = "growth_curves"
            ),
            selected = "trajectories"
          ),
          selectInput(
            "selected_function_word",
            "Select Function Word",
            choices = function_words,
            selected = function_words[[1]]
          ),
          conditionalPanel(
            condition = "input.traj_view == 'trajectories'",
            selectInput(
              "plot_mode",
              "Overlay Mode",
              choices = c(
                "Single Child" = "single",
                "Overlay Selected Children" = "multi_select",
                "Overlay Top 10 Children (Global)" = "all_top_ten"
              ),
              selected = "single"
            ),
            conditionalPanel(
              condition = "input.plot_mode == 'single'",
              selectInput(
                "selected_child_display",
                "Select Target Child",
                choices = child_list_all,
                selected = child_list_all[[1]]
              )
            ),
            conditionalPanel(
              condition = "input.plot_mode == 'multi_select'",
              selectInput(
                "selected_children_multi",
                "Select Target Children (any corpus)",
                choices = child_list_all,
                selected = child_list_all[seq_len(min(3, length(child_list_all)))],
                multiple = TRUE
              )
            ),
            conditionalPanel(
              condition = "input.plot_mode == 'all_top_ten'",
              tags$p("Plot overlays the top ten children (by total token count, 12-48mo) across all collections/corpora.")
            )
          ),
          conditionalPanel(
            condition = "input.traj_view == 'population_trajectories'",
            tags$h4("Population trajectories"),
            tags$p("description of population trajectories here!")
          ),
          conditionalPanel(
            condition = "input.traj_view == 'growth_curves'",
            tags$h4("Growth curves"),
            tags$p("description of growth curves here!")
          )
        ),
        mainPanel(
          conditionalPanel(
            condition = "input.traj_view == 'trajectories'",
            plotOutput("cumulativePptPlot")
          ),
          conditionalPanel(
            condition = "input.traj_view == 'population_trajectories'",
            plotOutput("populationTrajPlot")
          ),
          conditionalPanel(
            condition = "input.traj_view == 'growth_curves'",
            plotOutput("functionWordGrowthCurvePlot")
          ),
          tags$br(),
          tags$h4("Current Literature Summary"),
          uiOutput("functionWordLiterature")
        )
      )
    ),
    tabPanel(
      title = HTML(sprintf('<span style="color:%s;font-weight:bold;">Function Word Literature</span>', aggie_gold)),
      sidebarLayout(
        sidebarPanel(
          tags$h3("Edit Literature Summaries"),
          tags$p("Edit the literature summary associated with each function word in a central YAML file found in 'literature/function_word_literature.yaml'. To update literature entries, please edit that file directly (outside this dashboard)."),
          tags$br(),
          tags$p("Below is a read-only display of the current summaries.")
        ),
        mainPanel(
          tableOutput("literatureTable"),
          tags$br(),
          tags$p("To add or update a summary, edit the corresponding entry in the literature.yaml file in the repo and then reload the dashboard :)")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  output$populationTrajPlot <- renderPlot({
    req(input$traj_view == "population_trajectories", input$selected_function_word)
    w <- input$selected_function_word
    dat <- function_word_pop_traj_data %>%
      filter(word == w) %>%
      arrange(target_child_age)
    validate(need(nrow(dat) > 0, "No data for selected function word."))
    ggplot(dat, aes(x = target_child_age, y = cumulative_ppt)) +
      geom_line(color = aggie_blue, linewidth = 1.2) +
      geom_point(color = aggie_gold, size = 2.5) +
      labs(
        title = paste0("Population Trajectory: '", w, "' (all child data, cumulative PPT)"),
        x = "Child age (months)",
        y = "Cumulative PPT"
      ) +
      theme_bw(base_family = "Lato") +
      theme(
        plot.title = element_text(hjust = 0.5, color = "black", size = 18, face = "bold"),
        axis.title = element_text(size = 14, color = aggie_blue),
        axis.text = element_text(size = 12, color = aggie_blue)
      )
  })

  output$functionWordGrowthCurvePlot <- renderPlot({
    req(input$traj_view == "growth_curves", input$selected_function_word)
    w <- input$selected_function_word
    dat <- function_word_pop_traj_data %>% filter(word == w)
    curve <- gompertz_fitted_relfreq %>% filter(word == w, is.finite(fitted))
    validate(need(nrow(dat) > 0, "No data for selected function word."))
    p <- ggplot() +
      geom_point(
        data = dat,
        aes(x = target_child_age, y = cumulative_relfreq, color = "Observed (pooled)"),
        size = 2.5
      )
    if (nrow(curve) > 0) {
      p <- p + geom_line(
        data = curve,
        aes(x = target_child_age, y = fitted, color = "Gompertz fit"),
        linewidth = 1.2
      )
    }
    p +
      scale_color_manual(
        name = NULL,
        values = c("Observed (pooled)" = aggie_gold, "Gompertz fit" = aggie_blue)
      ) +
      scale_y_continuous(labels = scales::percent) +
      labs(
        title = paste0("Growth Curve: '", w, "' (cumulative relative frequency)"),
        x = "Child age (months)",
        y = "Cumulative relative frequency"
      ) +
      theme_bw(base_family = "Lato") +
      theme(
        plot.title = element_text(hjust = 0.5, color = "black", size = 18, face = "bold"),
        axis.title = element_text(size = 14, color = aggie_blue),
        axis.text = element_text(size = 12, color = aggie_blue),
        legend.position = "bottom"
      )
  })

  filteredData <- reactive({
    req(input$traj_view == "trajectories", input$selected_function_word, input$plot_mode)
    dat <- child_relfreq %>%
      filter(word == input$selected_function_word)
    if (input$plot_mode == "multi_select") {
      req(input$selected_children_multi)
      wanted <- input$selected_children_multi
      selected_rows <- child_name_map %>% filter(display_name %in% wanted)
      dat <- dat %>%
        inner_join(selected_rows, by = c("collection_name", "corpus_name", "target_child_name"))
    } else if (input$plot_mode == "all_top_ten") {
      kids <- top_ten_children %>%
        select(collection_name, corpus_name, target_child_name)
      dat <- dat %>%
        inner_join(kids, by = c("collection_name", "corpus_name", "target_child_name"))
    } else {
      req(input$selected_child_display)
      sel <- child_name_map %>%
        filter(display_name == input$selected_child_display) %>%
        slice(1)
      dat <- dat %>%
        filter(collection_name == sel$collection_name,
               corpus_name == sel$corpus_name,
               target_child_name == sel$target_child_name)
    }
    dat <- dat %>% arrange(target_child_name, target_child_age)
    dat$child_label <- paste0(dat$target_child_name, " (", dat$corpus_name, "|", dat$collection_name, ")")
    dat
  })

  output$cumulativePptPlot <- renderPlot({
    req(input$traj_view == "trajectories")
    plotdat <- filteredData()
    validate(
      need(nrow(plotdat) > 0, "No data for selection.")
    )
    num_kids <- length(unique(plotdat$child_label))
    pal <- scale_color_brewer(palette = ifelse(num_kids <= 8, "Dark2", "Paired"))
    ggplot(plotdat, aes(x = target_child_age, y = cumulative_ppt, color = child_label, group = child_label)) +
      geom_point(size = 2.5) +
      geom_line(size = 1.2) +
      pal +
      labs(
        title = paste0(
          "Cumulative PPT Trajectory for '",
          input$selected_function_word, "'\n",
          if (input$plot_mode == "all_top_ten") {
            " (Top 10 Children Across All Corpora/Collections)"
          } else if (input$plot_mode == "single") {
            paste0(" (", input$selected_child_display, ")")
          } else if (input$plot_mode == "multi_select") {
            " (Selected Children, any corpus/collection)"
          } else { "" }
        ),
        x = "Child age (months)",
        y = "Cumulative PPT",
        color = NULL
      ) +
      guides(color = guide_legend(
        title = "Child (Corpus | Collection)",
        title.theme = element_text(color = "black")
      )) +
      theme_bw(base_family = "Lato") +
      theme(
        plot.title = element_text(hjust = 0.5, color = "black", size = 18, face = "bold"),
        axis.title = element_text(size = 14, color = aggie_blue),
        axis.text = element_text(size = 12, color = aggie_blue),
        legend.title = element_text(color = "black"),
        legend.text = element_text(color = aggie_blue)
      )
  })

  output$functionWordLiterature <- renderUI({
    word <- input$selected_function_word
    summary <- function_word_lit[[word]]
    if (is.null(summary) || summary == "") {
      summary <- "No literature summary available yet for this function word."
    }
    HTML(summary)
  })

  output$literatureTable <- renderTable({
    tibble(
      `Function Word` = names(function_word_lit),
      `Literature Summary` = unname(unlist(function_word_lit))
    )
  }, striped = TRUE, hover = TRUE, spacing = "s")
}

