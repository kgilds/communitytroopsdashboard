#' gs_theme_538
#'
#' @param data the data frame you want to display as gt object.
#' @param ... extra param.
#'
#' @return a gt
#' @export
#'

gs_theme_538 <- function(data,...) {
  data %>%
    opt_all_caps()  %>%
    opt_table_font(
      font = list(
        google_font("Chivo"),
        default_fonts()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = "white", weight = px(2)
      ),
      locations = cells_body(
        columns = everything(),
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(data$`_data`)
      )
    )  %>%
    tab_options(
      column_labels.background.color = "white",
      table.border.top.width = px(3),
      table.border.top.color = "white",
      table.border.bottom.color = "white",
      table.border.bottom.width = px(3),
      column_labels.border.top.width = px(3),
      column_labels.border.top.color = "white",
      column_labels.border.bottom.width = px(3),
      column_labels.border.bottom.color = "black",
      data_row.padding = px(3),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      ...
    )
}

#' Complete list of palettes
#'
#' Use \code{\link{gs_palette}} to construct palettes of desired length.
#'
#' @export

outreach_palettes <- list(
  main = c("#00AE58", "#B2D234", "#FDDC00", "#FAA519", "#EE3123",
           "#EC008B", "#6E298C", "#6E298C", "#004E99", "#00AAE5"))





#' outreach_palette
#'
#' @param name of the palette
#' @param n is the number of colors
#'
#' @return a color scheme
#' @export
#'

outreach_palette <- function(name, n) {


  pal <- gs_palettes[[name]]
  if (is.null(pal))
    stop("Palette not found.")

  if (missing(n)) {
    n <- length(pal)
  }

  if (n > length(pal)) {
    stop("Number of requested colors greater than what palette can offer")
  }

  out <- pal[1:n]

  structure(out, class = "palette", name = name)
}
