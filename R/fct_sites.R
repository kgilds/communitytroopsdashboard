#' Program Sites
#' @description
#' Function to parse program sites
#' @param df
#' Should alawys be survy data
#' @return
#' a data frame
#' @export
#'
#' @examples
program_sites <- function(df){
  df %>%
    dplyr::select(girl_code, time_1, site, grant_1) %>%
    dplyr::rename(time = time_1) %>%
    dplyr::rename(grant = grant_1)
}


#' Site Report
#' @description
#' Function to put sites in a table
#' @param df
#' Always use program sites
#' @return
#' A table from the janitor package
#' @export
#'
#' @examples
#'

report_site <- function(df){
  df %>%
    dplyr::mutate_at(vars("site"), as.character) %>%
    janitor::tabyl(site,time) %>%
    #dplyr::select(site, starts_with("P")) %>%
    dplyr::arrange(site) %>%
    janitor::adorn_totals()

}


#' Top Sites Report
#' @description
#' Report to display the top 15 sites
#' @param df
#' Should be df result of program_sites
#' @return
#' A tbl
#' @export
#'
#' @examples
top_sites_tbl <- function(df){
  df %>%
    dplyr::group_by(time) %>%
    dplyr::count(site) %>%
    dplyr::top_n(15) %>%
    dplyr::arrange(desc(n))

}

#' @title  grant_g
#' @description
#' A ggplot graph of valid survey count
#' @param df is the data frame and it should always be grants
#' @return  a ggplot
#' @export

grant_g <- function(df){
  ggplot2::ggplot(df, aes(forcats::fct_infreq(grant), fill = time)) +
    geom_bar (stat = "count") +
    scale_fill_manual(values=c("#B2D234", "#00AE58")) +
    coord_flip() +
    #geom_text(aes(label = y), nudge_y = 11.0) +
    labs(title = "Number of Valid Surveys") +
    ylab("Survey Count") +
    xlab(NULL) +
    theme_light() +
    theme(axis.text.x = element_text(margin = margin(t = 7, b = 10)))

}
