#' home UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @import bs4Dash ggplot2 gt gtExtras
#' @importFrom shiny NS tagList
#' @export
mod_home_ui <- function(id) {
  ns <- NS(id)
  #tagList(
  bs4Dash::bs4TabItem(
    tabName = "home_ui_1",


    fluidRow(
      box(
        title = "Data Entry Stats",
        elevation = 2,
        side = "right",
        id = "funder",
        width = 12,
        status = "success",
        solidHeader = TRUE,
        collapsible = FALSE,
        closable = FALSE,
        maximizable = TRUE,
        fluidRow(
          bs4Dash::bs4ValueBoxOutput(ns("post_survey_count"), width = 3),
          bs4Dash::bs4ValueBoxOutput(ns("pre_survey_count"), width =3),
          #bs4ValueBoxOutput(ns("survey_count"), width = 3),
          #bs4ValueBoxOutput(ns("survey_errors"), width = 3),
          bs4ValueBoxOutput(ns("site_count"), width = 3)

        )
      )
    ),

    fluidRow(
      box(
        title = "Data Entry by Grant",
        elevation = 2,
        side = "right",
        id = "funder",
        width = 12,
        status = "success",
        solidHeader = TRUE,
        collapsible = FALSE,
        closable = FALSE,
        maximizable = TRUE,
        plotly::plotlyOutput(ns("grants_gg"))
      )

    ),#fluidrow,


    bs4TabCard(
      title = "Sites",
      id = "site",
      width = 12,
      collapsible = FALSE,
      closable = FALSE,
      maximizable = TRUE,
      type = "tabs",
      status = "success",
      solidHeader = TRUE,
      side = "right",


      tabPanel(
        "Top Sites",

        box(
          title = "Top 50% of Sites",
          elevation = 2,
          side = "right",
          id = "site",
          width = 12,
          status = "success",
          solidHeader = TRUE,
          collapsible = FALSE,
          closable = FALSE,
          maximizable = TRUE,
          plotly::plotlyOutput(ns("top_sites"))#, height = "650px")

        )
      ),
      tabPanel(
        "Bottom Sites",

        box(
          title = "Bottom 50% of Sites",
          elevation = 2,
          side = "right",
          id = "site",
          width = 12,
          status = "success",
          solidHeader = TRUE,
          collapsible = FALSE,
          closable = FALSE,
          maximizable = TRUE,
          plotly::plotlyOutput(ns("bottom_sites"))#, height = "650px")

        )
      )

    ),
    fluidRow(

      box(

        title = "Site Report",
        elevation = 2,
        side = "right",
        id = "funder",
        width = 12,
        status = "success",
        solidHeader = TRUE,
        collapsible = FALSE,
        closable = FALSE,
        maximizable = TRUE,
        gt::gt_output(ns("site_report"))

      )


    )


    #tabPanel(
    #title = "Date Entry by sites",

    #),

    #tabPanel(
    #title = "Data Entry by Grant",

    #),

    #tabPanel(
    #title =  "All Sites Report",


    #),

    #tabPanel(
    #title =  "All Sites Report",
    #DT::DTOutput(ns("site_report"))
    #)


  )
  #)

  #) #tabitem



}






#' home Server Functions
#'
#' @noRd
mod_home_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    thematic::thematic_shiny()


    sites_program <- reactive({



      # Program Pre and Program Post are made in workflow-22 --------------------


      pre_sites <- (program_pre_a) %>%
        dplyr::distinct(girl_code, time, .keep_all = TRUE) %>%
        dplyr::select(contains("time"), site, contains("grant"), girl_code)


      post_sites <- (program_post_a) %>%
        dplyr::distinct(girl_code, time, .keep_all = TRUE) %>%
        dplyr::select(contains("time"), site, contains("grant"), girl_code)


      sites_program <- rbind(pre_sites, post_sites)

    })

    top_sites <- reactive({
      sites_program() %>%
        dplyr::group_by(time) %>%
        dplyr::count(site)%>%
        dplyr::top_frac(.5)

    })

    bottom_sites <- reactive({
      bottom_frac <- 0.5
      result <- sites_program() %>%
        dplyr::group_by(time) %>%
        dplyr::count(site)%>%
        arrange(n) %>%
        slice(1:floor(n() * bottom_frac))

    })

    ### This is a key update here

    site_report <- reactive({
      site_report <- report_site(sites_program())

    })

    output$grants_gg <- renderPlotly({
      validate(
        need(nrow(sites_program()%>% dplyr::count(grant)) > 1, message = "Waiting for more data to be recorded")
      )

      grants_gg <- grant_g(sites_program())
      grants_gg <- ggplotly(grants_gg)

    })

    output$sites_gg <- renderPlotly({

      validate(
        need(nrow(sites_program()%>% dplyr::count(grant)) > 1, message = "Waiting for more data to be recorded")
      )


      sites_gg <- site_gg(top_sites())
      sites_gg <- ggplotly(sites_gg)

      #sites_gg <- program_data %>%
      #ggplot(aes(forcats::fct_infreq(site), fill = grant)) +
      #geom_bar() +
      #coord_flip() +
      #labs(title = "Pre Surveys Count by site") +
      #xlab("Site") +
      #ylab("Survey Count") +
      #theme_light()


    })

    output$top_sites <- renderPlotly({

      validate(
        need(nrow(sites_program()%>% dplyr::count(grant)) > 1, message = "Waiting for more data to be recorded")
      )

      # Create a bar plot
      top_sites_p <- ggplot(top_sites(), aes(x = forcats::fct_reorder(site, n), y = n, fill = time)) +
        geom_bar(stat = "identity", position = "stack") +

        # Customize the colors as needed
        scale_fill_manual(values = c("#B2D234", "#00AE58")) +

        # Set plot labels and title
        labs(title = "Total Survey Count by Site",
             subtitle = "Top Half",
             x = "Site",
             y = "Survey Count") +

        # Flip the coordinates to create a horizontal bar plot
        coord_flip() +

        # Use a light theme
        theme_light() +

        # Customize text elements
        theme(text = element_text(family = "Arial", size = 13))

      top_sites_p <- ggplotly(top_sites_p)

    })

    output$bottom_sites <- renderPlotly({

      validate(
        need(nrow(sites_program()%>% dplyr::count(grant)) > 1, message = "Waiting for more data to be recorded")
      )

      # Create a bar plot
      bottom_sites_p <- ggplot(bottom_sites(), aes(x = forcats::fct_reorder(site, n), y = n, fill = time)) +
        geom_bar(stat = "identity", position = "stack") +

        # Customize the colors as needed
        scale_fill_manual(values = c("#B2D234", "#00AE58")) +

        # Set plot labels and title
        labs(title = "Total Survey Count by Site",
             subtitle = "Bottom Half",
             x = "Site",
             y = "Survey Count") +

        # Flip the coordinates to create a horizontal bar plot
        coord_flip() +

        # Use a light theme
        theme_light() +

        # Customize text elements
        theme(text = element_text(family = "Arial", size = 13))

      bottom_sites_p <- ggplotly(bottom_sites_p)

    })


    # new table ---------------------------------------------------------------

    output$site_report <- gt::render_gt({
      gt::gt(site_report()) %>%
        gs_theme_538() %>%
        cols_label(

          "site" = "Site"
        ) %>%
        opt_stylize(style = 6, color = "green") %>%
        gt::opt_interactive(
          use_search = TRUE,
          use_page_size_select = TRUE,
          page_size_default =  15
        )


    })



    #boxes

    output$post_survey_count <- renderbs4ValueBox({
      post_survey_count <- dim(program_post_a)[1]
      #post_survey_count <- post_survey_count[1]/5
      post_survey_count <- prettyNum(post_survey_count, big.mark = ",")
      bs4Dash::bs4ValueBox(
        subtitle = "Valid Post-Surveys",
        value = post_survey_count,
        color = "success",
        icon  = icon("line-chart")
      )
    })


    output$pre_survey_count <- renderbs4ValueBox({
      pre_survey_count <- dim(program_pre_a)[1]
      #pre_survey_count <- pre_survey_count[1]/5
      pre_survey_count <- prettyNum(pre_survey_count, big.mark = ",")
      bs4Dash::bs4ValueBox(
        subtitle = "Valid Pre-Surveys",
        value = pre_survey_count,
        color = "success",
        icon  = icon("line-chart")
      )
    })

    output$survey_count <- renderbs4ValueBox({
      survey_count <- dim(pre_survey_count + post_survey_count)
      survey_count <- survey_count[1]
      survey_count <- prettyNum(survey_count, big.mark = ",")
      bs4ValueBox(
        subtitle = "Valid Surveys",
        value = survey_count[1],
        color = "success",
        icon = icon("line-chart")
      )
    })

    output$site_count <- renderbs4ValueBox({
      site_count <- sites_program()%>%
        dplyr::count(site)
      #janitor::adorn_totals()%>%
      #dplyr::slice_tail()
      site_count <- dim(site_count)[1]
      bs4ValueBox(
        subtitle = "Number of Sites",
        value = site_count,
        color = "success",
        icon = icon("line-chart")
      )
    })

    output$survey_errors <- renderbs4ValueBox({
      survey_errors <- nrow(program_dupes)
      bs4ValueBox(
        subtitle = "Duplicates",
        value = survey_errors,
        status = "warning",
        icon = icon("exclamation-circle")
      )
    })



  })
}

## To be copied in the UI
# mod_home_ui("home_1")

## To be copied in the server
# mod_home_server("home_1")
