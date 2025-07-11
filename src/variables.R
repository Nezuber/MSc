#### define general variables  ----
# seminar
collected_participants_seminar <- c(1:7, 9:14)
# exclude 8: exclude left handed seminar participant

# full 32 participants
collected_participants <- c(1:16, 18:32)
# exclude 17: Perc Task "side" decisions before seeing stimuli since assumed 1 disc 

task_abbrevs <- c("G", "M", "P", "C") 
task_abbrevs_seminar <- c("G", "M", "P")

#### define column names ----
stim_col <- "Stimuli"
stim_eq_col <- "stimuli_eq"
block_col <- "Block"
FGAp_col <- "G12FGAp"
avg_FGAp_col <- "avg_FGAp"
fw_col <- "FW"

#### define analysis variables ----
chance_var <- 0.5
conf_var <- 0.95
eq_margin <- 0.05
eqb_C_var <- c(chance_var - eq_margin, chance_var + eq_margin)

#### define plot variables ----
curr_theme <- theme_bw()
acc_limits <- c(0,100)
task_colors <- c(
  "Grasp" = "#9467bd",
  "ManEst" = "#1f77b4",
  "Perc" = "#1f77b4",
  "Control" = "#1f77b4" 
)