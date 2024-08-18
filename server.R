require(here)
source(here("R/pkg_list.R"))

server <- function(input, output) {
  
  # ----------- Data Uploading -----------
  
  data <- reactive({
    # input$file1 will be NULL initially.
    req(input$file1)
    
    sw_dat <- read_delim(here("alvin_sleep_work_data.txt"), col_names = input$header, delim = input$sep, col_types = c("?ttccc"), na = c("Nat", "Nan"), quote = input$quote)
    
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
    
    return(sw_dat)
  })
  
  output$uploadInfo <- renderText({
    dt <- data()
    data_range <- range(dt$date)
    paste0("You have successfully uploaded a datafile.\n",
           "There are ", nrow(dt), " rows and ", ncol(dt), 
           " columns in the file. \nThe date range is from ", data_range[1], " to ", data_range[2])
  })
  
  
  output$contents <- renderTable({
    dt <- data()
    dt$date <- as.character(dt$date)
    dt$sleep_start <- as.character(dt$sleep_start)
    dt$sleep_end <- as.character(dt$sleep_end)
    return(dt)
  })
  
  
  
  output$timeline <- renderPlot({
    sw_dat <- data()
    sw_dat_datetime <- append_datetimes(sw_dat)
    
    # TODO: fix the ad-hoc color coding
    sw_dat_datetime_work <- sw_dat_datetime[-nrow(sw_dat_datetime), ]
    sw_dat_datetime_work$sleep_start_datetime <- sw_dat_datetime$sleep_end_datetime[-nrow(sw_dat_datetime)]
    sw_dat_datetime_work$sleep_end_datetime <- sw_dat_datetime$sleep_start_datetime[-1]
    
    sw_dat_datetime <- rbind(sw_dat_datetime, sw_dat_datetime_work)
    sw_dat_datetime$sleep_work_combo <- c(sw_dat$sleep_quality, sw_dat$ease_of_working[-nrow(sw_dat)])
    
    ggplot(data = sw_dat_datetime)+
      geom_rect(aes(xmin=sleep_start_datetime, 
                    xmax=sleep_end_datetime,
                    ymin=c(rep(-1, nrow(sw_dat)), rep(0, nrow(sw_dat) - 1)),
                    ymax=c(rep(0, nrow(sw_dat)), rep(1, nrow(sw_dat) - 1)), 
                    fill=sleep_work_combo))
  })
  
  # output$download_timeline <- downloadHandler(
  #   filename = function() {
  #     "timeline.png"
  #   },
  #   content = function(file) {
  #     dt <- data()
  #     png(file)
  #     plot <-  plot_top_n(dt,"city_of_contact", min(input$topCities,length(unique(dt$city_of_contact))))
  #     ggsave(file, plot, width = 10, height = 5)
  #     dev.off()
  #   }
  # )
  
  output$workEfficiencyPred <- renderText({
    sw_dat <- data()
    sw_lm <- sleep_work_lm(sw_dat)
    
    pred <- predict(sw_lm, newdata = data.frame(sleep_lengths = input$sleeplength*60, sleep_quality = input$sleepquality))
    
    paste0("The predicted work efficiency, on a scale of 1-5, is ", round(pred, digits = 1), ".") 
  })
  
}
