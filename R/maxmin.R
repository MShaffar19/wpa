#' @title Max-Min Scaling Function
#'
#' @description This function allows you to scale vectors or an entire data frame using the max-min scaling method
#' A numeric vector is always returned. Originally implemented in https://github.com/martinctc/surveytoolbox.
#'
#' @details This is used within `keymetrics_scan()` to enable row-wise heatmapping.
#'
#' @param x Pass a vector or the required columns of a data frame through this argument.
#' @keywords max-min
#' @export
#' @examples
#' numbers <- c(15, 40, 10, 2)
#' maxmin(numbers)
#' @export

maxmin <- function(x){
  if(any(is.na(x))){
    warning("Warning: vector contains missing values. Those values will return as NA.")
  }
  maxs <- max(x, na.rm = TRUE)
  mins <- min(x, na.rm = TRUE)
  as.numeric(scale(x,center=mins,scale=maxs-mins))
}
