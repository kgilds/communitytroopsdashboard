#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny plotly shinymanager
#' @noRd
app_server <- function(input, output, session) {


  res_auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials(
      data.frame(
        user = c("Community", "shinymanager"),
        password = c(Sys.getenv("outreach"), Sys.getenv("shinymanager")),
        start = c("2019-04-15"), # optinal (all others)
        #expire = c(NA, "2019-12-31"),
        admin = c(FALSE, TRUE),
        comment = "Simple and secure authentification mechanism
  for single ‘Shiny’ applications.",
        stringsAsFactors = FALSE
      )
    )
  )
  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })

  #mod_controlbar_server("controlbar_ui_1")
  mod_home_server("home_ui_1")
  #mod_grant_server("grant_ui_1")
  #mod_questions_server("questions_ui_1", openTab = openTab, s = s)
  #mod_questions_server("questions_ui_1" )
  #mod_results_server("results_ui_1")
  #mod_news_server("news_ui_1")

}
