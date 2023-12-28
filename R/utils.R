
# returns the component numbers within a string, e.g., "4,3"
component_nums <- function(x) {
  if (!is.na(x)) {
    as.numeric(str_split_1(x, ","))
  } else {
    NA
  }
}
