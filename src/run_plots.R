# plot several task accuracies in one plot
plot_task_accs <- function(dfs, value, addname) {
  
  theme_set(curr_theme)
  
  df_melt <- melt_dfs(dfs, c("Sub", "Task", value))
  
  # change accuracy scale to 0 to 100 for nicer plots
  df_melt <- mutate_if(df_melt, is.numeric, ~ . * 100)
  df_melt$Sub <- df_melt$Sub / 100
  
  # prep order in plot
  wanted_order <- sapply(dfs, function(x) x$Task[1])
  df_melt$Task <- factor(df_melt$Task, levels = wanted_order)
  
  mean_labels <- get_mean_labels(df_melt, value)
  
  plot <- ggplot(df_melt, aes(x = Task, y = get(value), color = Task)) +
    # ylim(0.35,1) +
    ylim(acc_limits) +
    labs(x = "Task", y = "Accuracy (%correct)") +
    geom_hline(yintercept = 50, color = "darkred", linetype = "dashed") +
    # Perc Accuracies of previous studies
    # geom_hline(yintercept = 0.58, color = "gray") +
    # geom_hline(yintercept = 0.627, color = "grey") +
    # geom_hline(yintercept = 0.69, color = "grey") +
    # geom_hline(yintercept = 0.667, color = "grey") +
    # geom_hline(yintercept = 0.70, color = "grey") +
    geom_beeswarm(cex = 2, shape = 16, stroke = 1, alpha = 0.5) +
    geom_boxplot(outlier.shape = NA,
                 varwidth = TRUE, 
                 alpha = 0, color = "black") +
    scale_color_manual(values = task_colors) +
    geom_text(data = mean_labels, 
              aes(x = Task, y = 95, 
                  label = paste0("Mean:\n",round(Mean, 1),"±",round(SEM, 1),"%")), 
              inherit.aes = FALSE, 
              color = "black",
              size = 3) 
  
  print(plot)
  
  ggsave(paste0("plots/task_accs_", vars$study_string, "_", value, "_",
                addname, ".png"), plot = plot, width = 15, height = 10, units = "cm")
}


# plot large - small apertures in grasping and manual estimation
plot_SLdiff <- function(df, value1, value2, addname) {
  
  theme_set(curr_theme)
  
  names(df$G)[names(df$G) == value1] <- "mean_SLdiff"
  names(df$M)[names(df$M) == value2] <- "mean_SLdiff"
  
  df_mean_SLdiff <- melt_dfs(list(df$G, df$M), c("Sub", "Task", "mean_SLdiff"))
  
  unique_meanSLdiff <- distinct(df_mean_SLdiff, Sub, Task, .keep_all = TRUE)
  
  mean_labels <- get_mean_labels(unique_meanSLdiff, "mean_SLdiff")
  
  plot <- ggplot(unique_meanSLdiff, aes(x = Task, y = mean_SLdiff, color = Task)) +
    ylim(-1.25,3) +
    labs(x = "Task", y = "Average Large - Small Aperture (mm)") +
    geom_hline(yintercept = 0.5, color = "darkred", linetype = "dashed") +
    geom_beeswarm(cex = 2, shape = 16, stroke = 1, alpha = 0.5) +
    scale_color_manual(values = task_colors) +
    geom_boxplot(outlier.shape = NA,
                 varwidth = TRUE, 
                 alpha = 0, color = "black") +
    geom_text(data = mean_labels,
              aes(x = Task, y = 2.75,
                  label = paste0("Mean:\n",round(Mean, 2),"±",round(SEM, 2),"mm")),
              inherit.aes = FALSE,
              color = "black",
              size = 3)
  
  print(plot)
  
  ggsave(paste0("plots/SLdiff_", vars$study_string, "_",
                addname, ".png"), plot = plot, width = 10, height = 10, units = "cm")
}

# plot errors per task
plot_errors <- function(dfs, addname) {
  
  theme_set(curr_theme)
  
  # prep df
  res <- list()
  for(d in dfs) {
    agg <- aggregate(Errors ~ Sub, data = d, FUN = max, na.rm = TRUE)
    if(d$Task[1] == "ExPerc") {
      agg$Task <- "Control"
    }
    else {
      agg$Task <- d$Task[1]
    }
    
    res[[length(res) + 1]] <- agg
  }
  
  melted_df <- do.call(rbind, res)
  
  wanted_order <- sapply(dfs, function(x) x$Task[1])
  wanted_order[wanted_order == "ExPerc"] <- "Control"
  melted_df$Task <- factor(melted_df$Task, levels = wanted_order)
  
  plot <- ggplot(melted_df, aes(x = Task, y = Errors, color = Task)) +
    ylim(0, 32) +
    labs(x = "Task", y = "Errors") +
    geom_beeswarm(cex = 1, shape = 16, stroke = 1, alpha = 0.5) +
    scale_color_manual(values = task_colors)
  
  print(plot)
  
  ggsave(paste0("plots/errors_", vars$study_string, "_", 
                addname, ".png"), plot = plot, width = 15, height = 7, units = "cm")
}


# plot comparison of accuracies in two tasks and their correlation
plot_comp_2tasks_xy <- function(df, task_x, task_y, addname) {
  
  theme_set(curr_theme)
  
  df_bound <- cbind(Sub = df$G$Sub, Grasp = df$G$accuracy, ManEst = df$M$accuracy,
                    Perc = df$P$accuracy, Control = df$C$accuracy)
  df_bound <- as.data.frame(df_bound)
  
  df_bound <- df_bound * 100
  
  plot <- ggplot(df_bound, aes(x = get(task_x), y = get(task_y), group = Sub)) +
    ylim(acc_limits) +
    xlim(acc_limits) +
    labs(x = paste("Average", task_x, "Accuracy (%correct)"), 
         y = paste("Average", task_y, "Accuracy (%correct)")) +
    geom_point(shape = 16, stroke = 1, alpha = 0.5) +
    annotate(geom = "text", 
             x = 50, y = 90, 
             label = paste0("Correlation:\n",
                            round(cor(df_bound[[task_y]], df_bound[task_x]), 3)))
  
  print(plot)
  ggsave(paste0("plots/comp_", task_x, "_", task_y,"_", vars$study_string, "_", 
                addname, ".png"), plot = plot, width = 8, height = 8, units = "cm")
}


# plot comparison of apertures in grasp and manest and their correlation
plot_MG_comp_aperture <- function(df, addname) {
  
  theme_set(curr_theme)
  
  df_bound <- data.frame(Sub = integer(), MaxAp = numeric(), ManEst = numeric())
  
  agg_G <- aggregate(MaxAp ~ Sub, data = df$G, FUN = mean, na.rm = TRUE)
  agg_M <- aggregate(ManEst ~ Sub, data = df$M, FUN = mean, na.rm = TRUE)
  
  df_merged <- merge(agg_G, agg_M, by = "Sub")
  
  plot <- ggplot(df_merged, aes(x = MaxAp, y = ManEst, group = Sub)) +
    ylim(40,90) +
    xlim(40,90) +
    labs(x = "Average MGA (mm)", y = "Average manual estimation (mm)") +
    geom_point(shape = 16, stroke = 1, alpha = 0.5) +
    annotate(geom = "text", 
             x = 65, y = 83, 
             label = paste0("Correlation:\n",
                            round(cor(df_merged$MaxAp, df_merged$ManEst), 3)))
  
  print(plot)
  
  ggsave(paste0("plots/comp_MG_", vars$study_string, "_", 
                addname, ".png"), plot = plot, width = 8, height = 8, units = "cm")
}


# run and plot bootstrap 
run_and_plot_bootstrap <- function(sample_1, sample_2, reps = 100, addname,
                                   amount_subjects = 48, 
                                   amount_trials = 128, 
                                   margins = seq(0.01, 0.06, by=0.001), 
                                   expected_mean_difference = 0.03) {
  
  df_bootstrap <- bootstrap(sample_1, sample_2, reps, amount_subjects, 
                            amount_trials, margins, expected_mean_difference) 
  
  df_bootstrap_points <- prep_plot_bootstrap(df_bootstrap, reps, margins)
  
  plot_bootstrap(df_bootstrap_points, margins, addname)
  
  print(paste("80% margin:",
              df_bootstrap_points[df_bootstrap_points$percent_significant > 0.8,]$margin[1]))
  print(paste("95% margin:",
              df_bootstrap_points[df_bootstrap_points$percent_significant > 0.95,]$margin[1]))
}


# plot bootstrap results
plot_bootstrap <- function(df_points, margins, addname) {
  
  theme_set(curr_theme)
  
  plot <- ggplot(df_points, aes(x = margin_col, y = percent_significant)) + 
    ylim(c(0,1)) +
    xlim(c(margins[1], margins[length(margins)])) +
    labs(x = "Equivalence Margin", y = "% Significant at Equivalence Margin (power)") +
    geom_hline(yintercept = 0.8, color = "orange") +
    geom_vline(xintercept = df_points[df_points$percent_significant > 0.80,]$margin_col[1], color = "orange") +
    geom_hline(yintercept = 0.95,color = "red") +
    geom_vline(xintercept = df_points[df_points$percent_significant > 0.95,]$margin_col[1], color = "red") +
    geom_point(color = "black") +
    geom_line(color = "black", linetype = "dotted", lwd = .5)
  
  print(plot)
  
  ggsave(paste0("plots/bootstrap_", vars$study_string, "_", 
                addname, ".png"), plot = plot, width = 10, height = 10, units = "cm")
}


# plot reaction times 
plot_RTs <- function(df, addname) {
  
  theme_set(curr_theme)
  
  agg_RT <- aggregate(RT ~ Sub, data = df, FUN = function(x) c(Mean = mean(x), 
                                                                   Max = max(x)))
  agg_RT <- do.call(data.frame, agg_RT)
  
  plot <- ggplot(agg_RT, aes(x = vars$study_string, y = RT.Mean)) +
    ylim(c(0,2000)) +
    labs(x = "Study", y = "Average RT (ms)") +
    geom_beeswarm(cex = 2, shape = 16, stroke = 1, alpha = 0.5, color = task_colors[3]) +
    geom_boxplot(outlier.shape = NA,
                 varwidth = TRUE,
                 alpha = 0, color = "black")
  
  print(plot)
  
  ggsave(paste0("plots/RTs_", vars$study_string, "_", 
                addname, ".png"), plot = plot, width = 10, height = 10, units = "cm")
}

# plot d prime for perc and control
plot_d_prime <- function(dfs, addname) {
  
  theme_set(curr_theme)
  
  df_melt <- melt_dfs(dfs, c("Sub", "Task", "d_prime"))
  
  # prep order in plot
  wanted_order <- sapply(dfs, function(x) x$Task[1])
  df_melt$Task <- factor(df_melt$Task, levels = wanted_order)
  
  mean_labels <- get_mean_labels(df_melt, "d_prime")
  
  plot <- ggplot(df_melt, aes(x = Task, y = d_prime, color = Task)) +
    ylim(-0.5,2.5) +
    labs(x = "Task", y = "d'") +
    geom_beeswarm(cex = 2, shape = 16, stroke = 1, alpha = 0.5) +
    geom_boxplot(outlier.shape = NA,
                 varwidth = TRUE, 
                 alpha = 0, color = "black") +
    scale_color_manual(values = task_colors) +
    geom_text(data = mean_labels, 
              aes(x = Task, y = 2.2, 
                  label = paste0("Mean:\n",round(Mean, 3),"±",round(SEM, 3))), 
              inherit.aes = FALSE, 
              color = "black",
              size = 3) 
  
  print(plot)
  
  ggsave(paste0("plots/d_prime_", vars$study_string, "_",
                addname, ".png"), plot = plot, width = 15, height = 10, units = "cm")
}


# plot size estimations from the questionnaire
plot_size_est <- function(df_csv, viable_participants, addname) {
  theme_set(curr_theme)
  df_csv <- df_csv[c(viable_participants), ]
  
  df <- data.frame(sub = integer(), size = numeric())
  for(p in 1:length(viable_participants)) {
    for(i in 1:length(df_csv$est[[p]])) {
      row <- data.frame(sub = p, size = df_csv$est[[p]][i])
      df <- rbind(df, row)
    }
  }
  
  # sort in mean estimation in ascending order
  first_sizes <- aggregate(size ~ sub, data = df, FUN = mean)
  first_sizes <- first_sizes[order(first_sizes$size, decreasing = FALSE), ]
  first_sizes$new_sub  <- seq.int(nrow(first_sizes))
  first_sizes <- first_sizes[order(first_sizes$sub, decreasing = FALSE), ]
  
  for(i in 1:length(df$sub)) {
    sub <- df$sub[i]
    df$new[i] <- first_sizes[sub,]$new_sub
  }
  
  plot <- ggplot(df, aes(x = size, y = new)) +
    xlim(0,80) +
    labs(x = "Size Estimation (mm)", y = "Participant") +
    geom_point() 
  
  print(plot)
  
  ggsave(paste0("plots/questionnaire_main_", 
                addname, ".png"), plot = plot, width = 15, height = 8, units = "cm")
}

