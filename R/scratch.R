require(here)
source(here("R/pkg_list.R"))

sw_dat <- read_delim(here("alvin_sleep_work_data.txt"), delim = " ", col_types = c("?ttccc"), na = c("Nat", "Nan"))
sw_dat <- sw_dat

# average the "#,#" strings in sleep_quality and ease_of_working
for (i in 1:nrow(sw_dat)) {
  sw_dat$sleep_quality[i] <- mean(component_nums(sw_dat$sleep_quality[i]))
  sw_dat$ease_of_working[i] <- mean(component_nums(sw_dat$ease_of_working[i]))
}

# sw_dat$sleep_quality <- as.numeric(str_length(sw_dat$sleep_quality) > 1, 
#                                    str_split_1("4,3", ","), 
#                                    )

# 


