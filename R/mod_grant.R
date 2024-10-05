#' grant UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_grant_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' grant Server Functions
#'
#' @noRd 
mod_grant_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_grant_ui("grant_1")
    
## To be copied in the server
# mod_grant_server("grant_1")
