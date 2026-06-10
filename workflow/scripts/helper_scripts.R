library("dplyr")
library("zoo")

#______________________________
# Automated truncLen function
#______________________________

calculate_truncLen <- function(quality_data, q_threshold = 30, window_size = 5){
  # 1. Calculate the average quality score per Cycle (base position)
  df_summary <- quality_data %>% group_by(Cycle) %>%
    summarize(Mean = sum(Score * Count) / sum(Count), .groups = 'drop') %>%
    arrange(Cycle)
  
  # 2. Calculate a rolling average of the calculated mean scores per cycle
  # This is to prevent that a single bad cycle does not prematurely chop the sequence
  df_summary$rolling_qual <- rollmean(df_summary$Mean, k = window_size, fill = NA, align = "right")
  
  # 3. Find all cycles where the rolling average drops below the q_threshold and create a DF
  # With this bad reads
  bad_cycles <- df_summary %>% filter(rolling_qual < q_threshold)
  
  # 4. Determine the truncation length
  # If the rolled quality never drops below the threshold, keep all cycles
  if (nrow(bad_cycles) == 0) { 
    trunc_len <- max(df_summary$Cycle)
  } else { # If rolled mean drops, find the first time it happens
    first_bad_cycle <- min(bad_cycles$Cycle)
    
    # Subtract the window size to ensure to cut before the bad cycle starts
    trunc_len <- first_bad_cycle - window_size
  }
  
  return(trunc_len)
}
