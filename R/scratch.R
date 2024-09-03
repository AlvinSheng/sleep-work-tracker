require(here)
source(here("R/pkg_list.R"))

sw_dat <- read_delim(here("alvin_sleep_work_data.txt"), delim = " ", col_types = c("?ttccc"), na = c("Nat", "Nan"))

sw_dat$date <- as.Date(sw_dat$date, "%m/%d/%y")


# for removing the sleep sessions that cross midnight
cross_midnight <- rep(F, length = nrow(sw_dat))

# average the "#,#" strings in sleep_quality and ease_of_working
for (i in 1:nrow(sw_dat)) {
  sw_dat$sleep_quality[i] <- mean(component_nums(sw_dat$sleep_quality[i]))
  sw_dat$ease_of_working[i] <- mean(component_nums(sw_dat$ease_of_working[i]))
  
  if (sw_dat$sleep_end[i] < sw_dat$sleep_start[i]) {
    cross_midnight[i] <- T
  }
}

sw_dat$sleep_quality <- as.numeric(sw_dat$sleep_quality)
sw_dat$ease_of_working <- as.numeric(sw_dat$ease_of_working)

sw_dat <- sw_dat[!cross_midnight, ]
# which(sw_dat$sleep_end < sw_dat$sleep_start)






#######

# Spot check, to catch sleep sessions longer than 12 hours, e.g., 10 am to 6 am. That probably should've been 10 pm to 6 am.
# Can do this easily by having two cases focused on trying to correct sleep sessions that cross 12 am midnight or 12 pm noon
# That is, if the times have both am's or pm's, the sleep_start > sleep_end, and overlap the next sleep session.

sw_dat <- read_delim(here("alvin_sleep_work_data.txt"), delim = " ", col_types = c("?ttccc"), na = c("Nat", "Nan"))

# sw_dat$date <- as.Date(sw_dat$date, "%m/%d/%y")

# sw_dat_datetime <- append_datetimes(sw_dat)

# # extract am's or pm's
# start_end_ap <- data.frame(start_ap = substring(sw_dat$sleep_start, str_length(sw_dat$sleep_start) - 1, str_length(sw_dat$sleep_start)), 
#                end_ap = substring(sw_dat$sleep_end, str_length(sw_dat$sleep_end) - 1, str_length(sw_dat$sleep_end)))

# find cases where sleep_end is less than sleep_start, except in the case it crosses midnight

which(sw_dat$sleep_start) # add one to get the actual line within sublime text

# actually, this is a good chance to make a helper function to loop past midnight and get the correct datetime. Then, you can take the difference and inspect suspiciously long ones that are more than 12 hours long


