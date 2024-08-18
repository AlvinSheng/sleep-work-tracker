require(here)
source(here("R/pkg_list.R"))

sw_dat <- read_delim(here("alvin_sleep_work_data.txt"), delim = " ", col_types = c("?ttccc"), na = c("Nat", "Nan"))

sw_dat$date <- as.Date(sw_dat$date, "%m/%d/%y")

# TODO: don't omit, but account for it
# for removing the sleep sessions that cross midnight
cross_midnight <- rep(F, length = nrow(sw_dat))
# TODO: modify
# average the "#,#" strings in sleep_quality and ease_of_working
for (i in 1:nrow(sw_dat)) {
  sw_dat$sleep_quality[i] <- mean(component_nums(sw_dat$sleep_quality[i]))
  sw_dat$ease_of_working[i] <- mean(component_nums(sw_dat$ease_of_working[i]))
  
  if (sw_dat$sleep_end[i] < sw_dat$sleep_start[i]) {
    cross_midnight[i] <- T
  }
}
# TODO: figure out why sleep_quality and ease_of_working automatically turns into character
sw_dat$sleep_quality <- as.numeric(sw_dat$sleep_quality)
sw_dat$ease_of_working <- as.numeric(sw_dat$ease_of_working)

sw_dat <- sw_dat[!cross_midnight, ]
# which(sw_dat$sleep_end < sw_dat$sleep_start)


