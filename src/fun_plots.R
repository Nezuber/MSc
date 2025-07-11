# melts list of dfs with specified columns
melt_dfs <- function(dfs, cols) {
  selected <- lapply(dfs, function(df) df[cols])
  melted <- do.call(rbind, selected)
  return(melted)
}

get_mean_labels <- function(df, value) {
  mean_labels <- aggregate(df[[value]], 
                             by = list(df$Task), function(x) c(Mean = mean(x), SEM = sem(x), Median = median(x)))
  mean_labels <- do.call(data.frame, mean_labels)
  colnames(mean_labels) <- c("Task", c("Mean", "SEM", "Median"))
  
  return(mean_labels)
}

bootstrap <- function(sample_1, sample_2, reps, amount_subjects, amount_trials, margins, expected_mean_difference) {
  df_reps <- data.frame(dataset = numeric(reps), df_acc_diff = numeric(reps), 
                        CIL = numeric(reps), CIH = numeric(reps), 
                        matrix(0, ncol = length(margins), nrow = reps, dimnames = list(NULL, margins)),
                        check.names = FALSE)
  
  for(j in 1:reps) {
    df_sub <- data.frame(sub = numeric(amount_subjects), acc1 = numeric(amount_subjects), acc2 = numeric(amount_subjects), sub_acc_diff = numeric(amount_subjects))
    for(i in 1:amount_subjects) {
      df_sub$sub[i] <- i
      # sample and get accuracy from sample
      sub_sample1_trials <- sample(sample_1, amount_trials, replace = TRUE)
      df_sub$acc1[i] <- mean(sub_sample1_trials)
      
      sub_sample2_trials <- sample(sample_2, amount_trials, replace = TRUE)
      df_sub$acc2[i] <- mean(sub_sample2_trials)
      
      # - 0.03 to get mean to 0
      # + to add variability back in best 0.02
      df_sub$sub_acc_diff[i] <- df_sub$acc1[i] - df_sub$acc2[i] - 0.03 + expected_mean_difference
    }
    
    df_t <- t.test(df_sub$sub_acc_diff, conf.level=0.9)
    df_reps$dataset[j] <- j
    df_reps$df_acc_diff[j] <- mean(df_sub$sub_acc_diff) 
    df_reps$CIL[j] <- df_t$conf.int[1]
    df_reps$CIH[j] <- df_t$conf.int[2]
    
    for(m in 1:length(margins)) {
      df_reps[[4+m]][j] <- ifelse(df_reps$CIL[j] > -margins[m] && df_reps$CIH[j] < margins[m], 1, 0)
    }
  }
  
  return(df_reps)
}

prep_plot_bootstrap <- function(df, reps, margins) {
  df_points <- data.frame(x_axis = 1:length(margins), percent_significant = numeric(length(margins)), margin_col = margins)
  for (i in 1:length(margins)) {
    df_points$percent_significant[[i]] <- sum(df[[4+i]])/reps
  }
  
  return(df_points)
}


