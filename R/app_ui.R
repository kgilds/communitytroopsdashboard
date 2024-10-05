#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny bs4Dash waiter fresh
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic

    bs4Dash::dashboardPage(
      help = NULL,
      freshTheme = create_theme(
        bs4dash_vars(
          navbar_light_color = "#bec5cb",
          navbar_light_active_color = "#00AE58",
          navbar_light_hover_color = "#FFF"
        )


      ),
      title = "GSWCF Community <br> Troops",
      #preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),


      header = dashboardHeader(
        title = dashboardBrand(
          title = "Community Troops",
          color = "success",
          href = "",
          image = "https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Sense-of-Self_RGB_final.png"
        ),

        leftUi = tagList(
          dropdownMenu(
            badgeStatus = "info",
            type = "notifications",
            userMessage(
              author = "Kevin",
              date = "Data updated",
              "07-30-2024"
            )



          )
        ),

        rightUi = tagList(
          dropdownMenu(
            attachmentBlock(
              image = "https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Sense-of-Self_RGB_final.png",
              title = "Survey Link",
              href = "https://girlscoutsusa.ca1.qualtrics.com/jfe/form/SV_0IfNcs33gZ3MI06"
            ),


            attachmentBlock(
              image = "https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Positive-Values_RGB_final.png",
              title = "Method Resources",
              href = "https://gsusa.app.box.com/s/myd2mm5ch25o1l2zv6zwyc8gtyshdbtf/file/97385288160?sb=/details"
            )

          )

        )
      ),

      dashboardSidebar(
        width = "50px",
        sidebarUserPanel(
          image = "https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Positive-Values_RGB_final.png",
          name = "Welcome!"
        ),
        sidebarMenu(
          id = "sidebarmenu",
          sidebarHeader("Menu"),
          menuItem(
            "Home",
            tabName = "home_ui_1",
            icon = icon("sliders")
          )
          #menuItem(
           # "Grant",
            #tabName = "grant_ui_1",
            #icon = icon("dollar")
          #),

          #menuSubItem(
           # " Survey Questions",
            #tabName = "questions_ui_1"
          #),

          #menuItem(
            #"Results",
            #tabName = "results_ui_1",
          #  icon = icon("poll-h")
          #),
          #menuItem(
           # "News",
            #tabName = "news_ui_1",
            #icon = icon("newspaper")
          #)
        ) #sidebarmenu

      ), #sidebar

      bs4Dash::dashboardBody(
        tabItems(
          mod_home_ui("home_ui_1")
          #mod_grant_ui("grant_ui_1"),
          #mod_questions_ui("questions_ui_1"),
          #mod_results_ui("results_ui_1"),
          #mod_news_ui("news_ui_1")
        )

      ),
      footer =  bs4DashFooter(
        fixed = FALSE,
        left = a(
          h5("Built with",
             img(src = "https://github.com/rstudio/shiny/blob/main/man/figures/logo.png?raw=true", height = "30px"),
             "by",
             img(src = "https://d33wubrfki0l68.cloudfront.net/521a038ed009b97bf73eb0a653b1cb7e66645231/8e3fd/assets/img/rstudio-icon.png", height = "30px")
          ),
        ),
        right = a(

          href = "https://kgilds.rbind.io/",
          target = '_blank', "Developed by Kevin Gilds"

        )

      )
      #title = "bs4Dash Showcase"


    )

  )#tag

}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "communitytroopsdashboard"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
