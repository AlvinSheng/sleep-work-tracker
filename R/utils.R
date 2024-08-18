
# returns the component numbers within a string, e.g., "4,3"
component_nums <- function(x) {
  if (!is.na(x)) {
    as.numeric(str_split_1(x, ","))
  } else {
    as.numeric(NA)
  }
}

# adding two additional columns to sw_dat, that append the time to its date
append_datetimes <- function(sw_dat) {
  # TODO: include timezone by extracting it from misc_data
  sleep_start_datetime <- with(sw_dat, ymd(date) + hms(sleep_start))
  sleep_end_datetime <- with(sw_dat, ymd(date) + hms(sleep_end))
  
  return(sw_dat %>% add_column(sleep_start_datetime) %>% add_column(sleep_end_datetime))
}

# simple lm that just takes in the length and quality of nap
sleep_work_lm <- function(sw_dat) {
  # # getting rid of zero work
  # sw_dat <- sw_dat[sw_dat$ease_of_working > 0, ]
  
  # getting length of sleep sessions
  sleep_lengths <- as.numeric(sw_dat$sleep_end - sw_dat$sleep_start)
  
  sw_lm <- lm(ease_of_working ~ sleep_lengths + sleep_quality, data = sw_dat)
  
  return(sw_lm)
}

# TODO: deal with time points that go through midnight


