empty_analysis_df <- function() {
  return(
    data.frame(matrix(ncol = 10, nrow = 0, 
                      dimnames = list(NULL, 
                                      c("comparison", "estimate",
                                        "conf_95_l", "conf_95_u", 
                                        "t_tt", "p_tt",
                                        "conf_90_l", "conf_90_u", 
                                        "t_eq", "p_eq"))))
  )
}

run_chance_comparison <- function(df, value) {
  res <- empty_analysis_df()
  
  for (i in 1:vars$task_num) {
    curr_value <- if (i %in% c(3, 4)) "accuracy" else value
    
    eqt <- t_TOST(x = df[[i]][[curr_value]], eqb = eqb_C_var, 
                  mu = 0, paired = FALSE)
    
    higher_p <- pmax(eqt$TOST$p.value[2], eqt$TOST$p.value[3])
    lower_t <- pmin(eqt$TOST$t[2], eqt$TOST$t[3])
    
    tt <- t.test(df[[i]][[curr_value]], mu = chance_var, 
                 alternative = "greater", conf.level = conf_var)
    
    res[i,] <- list(comparison = paste("50% vs", 
                                       substring(df[[i]]$Task[1], 1, 1)),
                    estimate = eqt$effsize$estimate[1] * 100,
                    conf_95_l = tt$conf.int[1]* 100,
                    conf_95_u = tt$conf.int[2]* 100,
                    t_tt = tt$statistic,
                    p_tt = tt$p.value,
                    conf_90_l = eqt$effsize$lower.ci[1]* 100,
                    conf_90_u = eqt$effsize$upper.ci[1]* 100,
                    t_eq = lower_t,
                    p_eq = higher_p)
  }
  return(res)
}

run_task_comparison <- function(df, value, comparisons) {
  res <- empty_analysis_df()
  
  for (i in 1:length(comparisons)) {
    eqt <- t_TOST(x = comparisons[[i]][[1]], y = comparisons[[i]][[2]], 
                  eqb = eq_margin, paired = TRUE)
    
    higher_p <- pmax(eqt$TOST$p.value[2], eqt$TOST$p.value[3])
    lower_t <- pmin(eqt$TOST$t[2], eqt$TOST$t[3])
    
    tt <- t.test(comparisons[[i]][[1]], comparisons[[i]][[2]], 
                 paired = TRUE, conf.level = conf_var)
    
    res[i,] <- list(comparison = names(comparisons)[i],
                    estimate = eqt$effsize$estimate[1] * 100,
                    conf_95_l = tt$conf.int[1]* 100,
                    conf_95_u = tt$conf.int[2]* 100,
                    t_tt = tt$statistic,
                    p_tt = tt$p.value,
                    conf_90_l = eqt$effsize$lower.ci[1]* 100,
                    conf_90_u = eqt$effsize$upper.ci[1]* 100,
                    t_eq = lower_t,
                    p_eq = higher_p)
  }
  return(res)
}