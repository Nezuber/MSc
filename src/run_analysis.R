test_SLdiff <- function(df, value1, value2) {
  
  names(df$G)[names(df$G) == value1] <- "mean_SLdiff"
  names(df$M)[names(df$M) == value2] <- "mean_SLdiff"
  
  df_mean_SLdiff <- melt_dfs(list(df$G, df$M), c("Sub", "Task", "mean_SLdiff"))
  
  unique_meanSLdiff <- distinct(df_mean_SLdiff, Sub, Task, .keep_all = TRUE)
  
  tg <- t.test(unique_meanSLdiff[unique_meanSLdiff$Task == "Grasp",]$mean_SLdiff, 
               mu = 0, alternative = "greater", conf.level = conf_var)
  
  tm <- t.test(unique_meanSLdiff[unique_meanSLdiff$Task == "ManEst",]$mean_SLdiff, 
               mu = 0, alternative = "greater", conf.level = conf_var)
  
  print(tg)
  print(tm)
}

run_analysis_overview <- function(df, value, is_seminar) {
  
  if(!is_seminar) {
    comparisons <- list(
      "G vs M" = list(df$G[[value]], df$M[[value]]),
      "G vs P" = list(df$G[[value]], df$P$accuracy),
      "M vs P" = list(df$M[[value]], df$P$accuracy),
      "P vs C" = list(df$P$accuracy, df$C$accuracy),
      "G vs C" = list(df$G[[value]], df$C$accuracy),
      "M vs C" = list(df$M[[value]], df$C$accuracy))
  }
  else {
    comparisons <- list(
      "G vs M" = list(df$G[[value]], df$M[[value]]),
      "G vs P" = list(df$G[[value]], df$P$accuracy),
      "M vs P" = list(df$M[[value]], df$P$accuracy))
  }
  
  chance_comp <- run_chance_comparison(df, value)
  task_comp <- run_task_comparison(df, value, comparisons)
  
  comp <- rbind(chance_comp, task_comp)
  
  # round p 
  comp$p_tt <- round(comp$p_tt, 3)
  comp$p_eq <- round(comp$p_eq, 3)
  
  # drop leading zeroes
  comp$p_tt <- gsub("^0\\.", "\\.",
                    gsub("^-0\\.", "-\\.",
                         as.character(comp$p_tt)))
  comp$p_eq <- gsub("^0\\.", "\\.",
                    gsub("^-0\\.", "-\\.",
                         as.character(comp$p_eq)))
  
  # round other cols
  comp <-  as.data.frame(lapply(comp,
                                function(x) if (is.numeric(x)){
                                  new <- round(x, 1)
                                  }
                                else x))
  
  write.csv(comp, file = paste0("txt/result_table_", 
                                       vars$study_string, ".txt"), row.names = FALSE)
  
  return(comp)
}