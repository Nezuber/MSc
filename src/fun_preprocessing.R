# various preprocess funcs ----

# run all needed grasp / manest aperture preprocessing functions
run_preprocess_apertures <- function(df, value) {
  
  if (!(stim_eq_col %in% colnames(df))) {
    df <- get_equal_stimuli(df)
  }
  
  df <- get_means(df, value) # optional if means for different disk sizes are wanted
  df <- mediansplit(df, value)
  df <- get_acc(df, paste0(value, "_ms_acc_trial"), c(1, 0))
  df <- get_mean_value_SLdiff_sub(df, value)
  
  return(df)
}

get_d_prime <- function(df) {
  df$d_prime <- 2*qnorm(df$Accuracy_acc )
  return(df)
}

sem <- function(x) {
  sd(x) / sqrt(length(x))
}

# create column binning 2 versions of same disc size
get_equal_stimuli <- function(df) {
  df[[stim_eq_col]] <- substr(df[[stim_col]],1,nchar(df[[stim_col]])-1)
  
  return(df)
}

get_means <- function(df, value) {
  curr_mean <- paste0( "mean_", value)
  curr_mean_S <- paste0( "S_", "mean_", value)
  curr_mean_L <- paste0( "L_", "mean_", value)
  
  df[[curr_mean]] <- mean(df[[value]])
  
  df[[curr_mean_S]] <- mean(df[[value]][df[[stim_eq_col]] == "D1"])
  df[[curr_mean_L]] <- mean(df[[value]][df[[stim_eq_col]] == "D2"])
  
  return(df)
}

mediansplit <- function(df,  value) {
  subj_median <- paste0("median_", value)
  curr_pred_ms <- paste0(value, "_pred_mediansplit")
  curr_acc_t <- paste0(value, "_ms_acc_trial")
  
  df[[subj_median]] <- median(df[[value]])
  
  # get median split prediction
  df[[curr_pred_ms]] <- ifelse(df[[value]] > df[[subj_median]], "D2", "D1")
  
  # median split accuracy trial
  df[[curr_acc_t]] <- ifelse(df[[curr_pred_ms]] == df[[stim_eq_col]], 1, 0)
  
  return(df)
}

get_mean_value_SLdiff_sub <- function(df, value) {
  curr_diff <- paste0("mean_SLdiff_", value)
  
  subset_S <- df[df$stimuli_eq == "D1",]
  subset_L <- df[df$stimuli_eq == "D2",]
  df[[curr_diff]] <- mean(subset_L[[value]]) - mean(subset_S[[value]])
  
  return(df)
}

# note: figner width correction was moved to MATLAB code
# fingerwidth_correction <- function(df, value) { 
#   corr_value_col <- paste0(value, "_FWcorr")
#   
#   for (block in unique(df[[block_col]])) {
#     df_curr_block <- df[df[[block_col]] == block,]
#     
#     # total trials before NaN removal
#     total_trials <- length(df_curr_block[[FGAp_col]]) 
#     
#     # create vec: for current block, non NaN FGAp values 
#     vec_FGAp_isnum_currblock <- lapply(df_curr_block[FGAp_col], function(d) d[!is.nan(d)])[[FGAp_col]]
#     
#     FGAp_total_isnum_currblock <- length(vec_FGAp_isnum_currblock)
#     FGAp_sum_isnum_currblock <- sum(vec_FGAp_isnum_currblock)
#     
#     if(total_trials != FGAp_total_isnum_currblock) {
#       diff = total_trials - FGAp_total_isnum_currblock
#       print(paste0("NaN FGAp found for ", value, " ", diff, " time(s) in block ", block, "!"))
#     }
#     
#     # calculate and save average FGAp for current block
#     df[df[[block_col]] == block, avg_FGAp_col] <- FGAp_sum_isnum_currblock / FGAp_total_isnum_currblock
#   }
#   
#   df[[fw_col]] <- df[[avg_FGAp_col]] - 40
#   df[[corr_value_col]] <- df[[value]] - df[[fw_col]]
#   
#   return(df)
# }