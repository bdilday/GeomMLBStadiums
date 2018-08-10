
#' MLB Spraychart
#'
#' This generates a spraychart - a scatter plot of \code{x, y} values
#' overlayed on a baseball field. It effectively overrides
#' \code{geom_point} and additionally concatenates a \code{geom_mlb_stadium} layer.
#'
#' @seealso
#'   \code{\link{geom_mlb_stadium}}
#'
#' @param mapping Set of aesthetic mappings created by \code{\link{aes}} or
#'   \code{\link{aes_}}. If specified and \code{inherit.aes = TRUE} (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply \code{mapping} if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If \code{NULL}, the default, the data is inherited from the plot
#'    data as specified in the call to \code{\link{ggplot}}.
#'
#'    A \code{data.frame}, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    \code{\link{fortify}} for which variables will be created.
#'
#'    A \code{function} will be called with a single argument,
#'    the plot data. The return value must be a \code{data.frame.}, and
#'    will be used as the layer data.
#' @param stat The statistical transformation to use on the data for this
#'    layer, as a string.
#' @param position Position adjustment, either as a string, or the result of
#'  a call to a position adjustment function.
#' @param na.rm If \code{FALSE}, the default, missing values are removed with
#'   a warning. If \code{TRUE}, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped.
#'   \code{FALSE} never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behavior from
#'   the default plot specification, e.g. \code{\link{borders}}.
#' @param stadium_aes mapping to pass to \code{geom_mlb_stadium}
#' @param stadium_ids character Vector of stadium ids.
#' @param stadium_segments character Vector of \code{stadium_segments} to display. Options are
#' 'outfield_inner', 'outfield_outer', 'infield', 'all'.
#' @param stadium_transform_coords boolean if \code{TRUE}, then transform the path data
#' according to \code{mlb_xy_transformation}
#' @param ... other arguments passed on to \code{\link{layer}}. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   \code{color = "red"} or \code{size = 3}. They may also be parameters
#'   to the paired geom/stat.
#' @export
#' @examples
#' g = ggplot() + geom_mlb_
#' set.seed(101)
#' batted_ball_data = data.frame(hc_x = rnorm(20, 125, 10), hc_y=rnorm(20, 100, 20))
#' batted_ball_data$team = rep(c("angels", "yankees"), each=10)
#' g <- ggplot(batted_ball_data) + geom_spraychart()
#'
geom_spraychart = function(mapping = NULL, data = NULL, stat = "identity",
                           position = "identity", na.rm = FALSE, show.legend = NA,
                           inherit.aes = TRUE,
                           stadium_aes = NULL,
                           stadium_ids = NULL,
                           stadium_segments = "outfield_outer",
                           stadium_transform_coords=FALSE,
                           ...) {

  list(
    geom_point(mapping = mapping, data = data, stat = stat,
               position = position, na.rm = na.rm, show.legend = show.legend, ...),

    geom_mlb_stadium(mapping = stadium_aes,
                     stadium_transform_coords = stadium_transform_coords,
                     stadium_ids = stadium_ids,
                     stadium_segments = stadium_segments)
  )


}

#' Geom MLB Stadium
#'
#' This draws the outline of an MLB stadium.
#'
#' The data are based on the SVG files used by MLBAM. The SVG files have been
#' converted to a \code{data.frame} for use with \code{ggplot2::geom_path}
#'
#' @seealso
#'   \code{\link{geom_spraychart}}
#'
#' @param mapping Set of aesthetic mappings created by \code{\link{aes}} or
#'   \code{\link{aes_}}. If specified and \code{inherit.aes = TRUE} (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply \code{mapping} if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If \code{NULL}, the default, the data is inherited from the plot
#'    data as specified in the call to \code{\link{ggplot}}.
#'
#'    A \code{data.frame}, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    \code{\link{fortify}} for which variables will be created.
#'
#'    A \code{function} will be called with a single argument,
#'    the plot data. The return value must be a \code{data.frame.}, and
#'    will be used as the layer data.
#' @param stat The statistical transformation to use on the data for this
#'    layer, as a string.
#' @param position Position adjustment, either as a string, or the result of
#'  a call to a position adjustment function.
#' @param na.rm If \code{FALSE}, the default, missing values are removed with
#'   a warning. If \code{TRUE}, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped.
#'   \code{FALSE} never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behavior from
#'   the default plot specification, e.g. \code{\link{borders}}.
#' @param stadium_ids mapping to pass to `If \code{TRUE}, the default, will check that
#'   supplied parameters and aesthetics are understood by the \code{geom} or
#'   \code{stat}. Use \code{FALSE} to suppress the checks.
#' @param params Additional parameters to the \code{geom} and \code{stat}.
#' @export
#' @examples
#' set.seed(101)
#' batted_ball_data = data.frame(hc_x = rnorm(20, 125, 10), hc_y=rnorm(20, 100, 20))
#' batted_ball_data$team = rep(c("angels", "yankees"), each=10)
#' g <- ggplot(batted_ball_data) + geom_spraychart(aes(x=hc_x, y=hc_y), stadium_ids = "angels")
#'
geom_mlb_stadium = function(mapping = NULL, data = NULL, stat = "identity",
                            position = "identity", na.rm = FALSE, show.legend = NA,
                            inherit.aes = FALSE,
                            stadium_ids = NULL,
                            stadium_segments = "outfield_outer",
                            stadium_transform_coords=FALSE,
                            ...) {

  mapping = aes(x=x, y=y, group=segment, ...)
  data = GeomMLBStadiums::MLBStadiumsPathData
 #data = read.csv("inst/extdata/mlb_stadia_paths.csv", stringsAsFactors = FALSE)

  if (is.null(stadium_ids)) {
    stadium_ids = "generic"
  } else if ("all" %in% stadium_ids) {
    stadium_ids = unique(data$team)
  } else if ("all_mlb" %in% stadium_ids) {
    stadium_ids = unique(data$team)
    cc = which(stadium_ids == "generic")
    if (length(cc) > 0) {
      stadium_ids = stadium_ids[-cc]
    }
  }


  data =
    do.call(rbind.data.frame,
            lapply(stadium_ids, function(s) {
              data[ (data$team == s),]
            })
    )

  if ("all" %in% stadium_segments) {
    # noop
  } else if (!is.null(stadium_segments)) {
    data = do.call(rbind.data.frame, lapply(stadium_segments, function(s) {
      data[ (data$segment == s),]
    })
    )
  }

  if (stadium_transform_coords) {
    data = mlbam_xy_transformation(data, x="x", y="y", column_suffix="")
  }

  layer(
    geom = GeomPath, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

