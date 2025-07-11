### libraries ----
library(TOSTER)
library(ggplot2)
library(readxl)
library(dplyr, warn.conflicts = FALSE)
library(ggbeeswarm)

### variables ----
w_dir <- getwd()
is_seminar <- 1 # toggles between pilot and main study data
# options(max.print = 10000)

### functions ----
source("src/load_sources.R")

# main ----
main <- function() {
  # set variables according to study
  vars <- set_vars_seminar_main(w_dir, is_seminar)
  
  # load files
  data <- read_multi_files(vars$data_dir, vars$files)
  
  # exclude participants with errors over errorlimit 
  viable_participants <- get_viable_participants(limit = 32, is_seminar, data, vars)
  
  prepro_data <- run_preprocess(viable_participants, data, is_seminar, vars)
  
  dfsum <- setNames(prepro_data[[1]], vars$task_abbrevs)
  data <- setNames(prepro_data[[2]], vars$task_abbrevs)
  
  ### run analysis ----
  # run t tests and equivalence tests
  res <- run_analysis_overview(dfsum, "accuracy", is_seminar)
  print(res)
  
  # run comparison if difference between large-small apertures is greater than 0
  test_SLdiff(data, "mean_SLdiff_MaxAp", "mean_SLdiff_ManEst")
  
  ### run plots ----
  ver <- "v1" # change to save different versions
  
  ## accuracy box plots for tasks in list with value
  # run with corrected finger width
  plot_task_accs(list(dfsum$G, dfsum$M), "accuracy_FW_corr", 
                 addname = ver)
  # run with only finger width values
  plot_task_accs(list(dfsum$G, dfsum$M), "accuracy_FW", 
                 addname = ver)
  # run with uncorrected finger width 
  plot_task_accs(list(dfsum$G, dfsum$M, dfsum$P), "accuracy", 
                 addname = ver)
  plot_task_accs(list(dfsum$G, dfsum$M, dfsum$P, dfsum$C), "accuracy", 
                 addname = ver)
  
  # average large-small aperture diff
  plot_SLdiff(data, "mean_SLdiff_MaxAp", "mean_SLdiff_ManEst", addname = ver)
   
  # errors per task
  plot_errors(data, addname = ver)
  
  # 2 tasks accuracy comparison
  plot_comp_2tasks_xy(dfsum, "Perc", "Control", addname = ver)
  plot_comp_2tasks_xy(dfsum, "Perc", "ManEst", addname = ver)
  plot_comp_2tasks_xy(dfsum, "Grasp", "ManEst", addname = ver)
  plot_comp_2tasks_xy(dfsum, "Perc", "Grasp", addname = ver)
  
  # manual estimation and grasping apertures comparison
  plot_MG_comp_aperture(data, addname = ver)
  
  ## run and plot bootstrap
  # ... with uncorrected apertures
  run_and_plot_bootstrap(data$G$MaxAp_ms_acc_trial, 
                         data$M$ManEst_ms_acc_trial,
                         reps = 1000,
                         addname = paste0("uncorrected_", ver))
  
  # ... with finger width correction
  run_and_plot_bootstrap(data$G$G12MaxAp_ms_acc_trial,
                         data$M$G12ManEst_ms_acc_trial,
                         reps = 1000,
                         addname = paste0("correctedFW_", ver))
  
  # plot RTs in perc
  plot_RTs(data$P, addname = ver)
  
  # plot signal detection theory d prime 
  plot_d_prime(list(dfsum$P, dfsum$C), addname = ver)
  print(sqrt(2) * mean(dfsum$C$d_prime))
  
  # questionnaire results
  csv <- read_prepro_csv(paste0(w_dir, "/data/"))
  plot_size_est(csv, viable_participants, addname = ver)
}
main()

