#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = shinymanager::secure_app(app_ui,tags_top =
                                      tags$div(
                                        tags$h4("GSWCF-Community Troops", style = "align:center"),
                                        tags$img(
                                          src = "https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Sense-of-Self_RGB_final.png", width = 100
                                        ),
                                      ),
                                    tags_bottom = tags$div(
                                      tags$p(
                                        "For any question, please  contact ",
                                        tags$a(
                                          href = "mailto:kevin.gilds@hey.com?Subject=Shiny%20aManager",
                                          target="_top", "Kevin Gilds, MPA"
                                        ))
                                    ),
                                    background = "linear-gradient(rgba(0, 0, 255, 0.5),
                       rgba(255, 255, 0, 0.5)),
                           url('https://raw.githubusercontent.com/kgilds/images/main/Outcomes-Icon_Sense-of-Self_RGB_final.png'), no-repeat center fixed;"),
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
