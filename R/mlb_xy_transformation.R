#' MLBAM X,Y transformation
#'
#' Transforms data in the \code{hc_x, hc_y} coordinates provided by
#' MLBAM. The resulting coordinate system is in units of feet, and
#' has home plate as \code{x=0, y=0} and the \code{y} coordinate
#' increases toward the pitcher's mound.
#'
#' The data are transformed according to
#' x -> scale * (x - 125) ;
#' y -> scale * (199 - y)
#'
#' @param data a \code{data.frame} containing \code{x, y} coordinates
#' @param x a character containing the name of the \code{x} coordinate
#' @param y a character containing the name of the \code{y} coordinate
#' @param column_suffix character. The transformed data will be named according
#' to the \code{x, y} names, with \code{column_suffix} appended.
#' @param scale numeric The scale to multiply the transformed data by. The default
#' sets pixel 51 and sets it to the y-location of second base, \code{90 x sqrt{2}}
#' @return \code{data.frame}. A copy of the input \code{data.frame} with the
#' transformed data appended
#' @export
#' @examples
#' set.seed(101)
#' batted_ball_data = data.frame(hc_x = rnorm(20, 125, 10), hc_y=rnorm(20, 100, 20))
#' # append transformed x, y data
#' transformed_data1 = mlbam_xy_transformation(batted_ball_data)
#' # overwrite the x, y data with transformed values
#' transformed_data2 = mlbam_xy_transformation(batted_ball_data, column_suffix="")
mlbam_xy_transformation = function(data,
                                   x="hc_x", y="hc_y",
                                   column_suffix="_",
                                   scale=2.495671) {
  data[,paste0(x, column_suffix)] = scale * (data[,x] - 125)
  data[,paste0(y, column_suffix)] = scale * (199 - data[,y])
  data
}
