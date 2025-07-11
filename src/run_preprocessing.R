### main preprocessing function ----
run_preprocess <- function(subjects, data, is_seminar, vars) {
  
  # save amount of subjects
  total_subs <- length(unique(data[[1]]$Sub)) 
  # only take viable participants
  data <- lapply(data, function(df) subset(df, Sub %in% subjects)) 
  num_subs <- length(unique(data[[1]]$Sub))
  
  if(TRUE) {
    print(paste("total subs: ", total_subs, "clean subs: ", num_subs))
    print(unique(data[[1]]$Sub))
  }
  
  # create dfs to save data later - per task, 1 line per sub
  dfsum_G <- data.frame(Sub = integer(num_subs), Task = "Grasp", accuracy = numeric(num_subs),
                        accuracy_FW_corr = numeric(num_subs), accuracy_FW = numeric(num_subs))
  dfsum_M <- data.frame(Sub = integer(num_subs), Task = "ManESt", accuracy = numeric(num_subs),
                        accuracy_FW_corr = numeric(num_subs), accuracy_FW = numeric(num_subs))
  dfsum_P <- data.frame(Sub = integer(num_subs), Task = "Perc", accuracy = numeric(num_subs),
                        d_prime = numeric(num_subs)) 
  if(!is_seminar){
    dfsum_E <- data.frame(Sub = integer(num_subs), Task = "Control", accuracy = numeric(num_subs),
                          d_prime = numeric(num_subs))
  }
  
  # create dfs to save data later - per task, 1 line per trial 
  data_G <- data.frame()
  data_M <- data.frame()
  data_P <- data.frame()
  if(!is_seminar){
    data_E <- data.frame()  
  }
  
  # counter for subjects to fill pre-allocated dfs
  row_counter <- 1
  
  for(i in subjects) {
    print(paste("----------- SUB:", i))
    
    # assign dfs to tasks for current subject 
    for(task in 1:vars$task_num) {
      if(data[[task]]$Task[1] == "Grasp") {
        sub_G <- data[[task]][data[[task]]$Sub == i,]
      }
      if(data[[task]]$Task[1] == "ManEst") {
        sub_M <- data[[task]][data[[task]]$Sub == i,]
      }
      if(data[[task]]$Task[1] == "Perc") {
        sub_P <- data[[task]][data[[task]]$Sub == i,]
      }
      if(!is_seminar & data[[task]]$Task[1] == "ExPerc") {
        sub_E <- data[[task]][data[[task]]$Sub == i,]
      }
    }
    
    if(FALSE) {
      print_quickcheck(sub_G, 'MaxAp')
      print_quickcheck(sub_M, 'ManEst')
      print_accuracy(sub_P, 'Accuracy')
      if(!is_seminar){
        print_accuracy(sub_E, 'Accuracy')
      }
    }
    
    # G ----
    # get finger width
    sub_G$FW <- sub_G$MaxAp - sub_G$G12MaxAp
    
    # uncorrected values
    sub_G <- run_preprocess_apertures(sub_G, "MaxAp")
    # corrected values
    sub_G <- run_preprocess_apertures(sub_G, "G12MaxAp")
    # finger width only 
    sub_G <- run_preprocess_apertures(sub_G, "FW")
    
    # M ----
    # get finger width
    sub_M$FW <- sub_M$ManEst - sub_M$G12ManEst
    
    # uncorrected values
    sub_M <- run_preprocess_apertures(sub_M, "ManEst")
    # corrected values
    sub_M <- run_preprocess_apertures(sub_M, "G12ManEst")
    # finger width only 
    sub_M <- run_preprocess_apertures(sub_M, "FW")
    
    # P ----
    sub_P <- get_acc(sub_P, "Accuracy", c("C", "F"))
    sub_P <- get_d_prime(sub_P)
    
    # E ----
    if(!is_seminar){
      sub_E <- get_acc(sub_E, "Accuracy", c("C", "F"))
      sub_E <- get_d_prime(sub_E)
    }
    
    # fill dfs per subj (using row in case of excluded subjects)
    dfsum_G[row_counter,] <- list(sub_G$Sub[[1]],
                                  "Grasp",
                                  sub_G$MaxAp_ms_acc_trial_acc[[1]],
                                  if ("G12MaxAp_ms_acc_trial_acc" %in% names(sub_G)) 
                                    sub_G$G12MaxAp_ms_acc_trial_acc[[1]] else NA,
                                  if ("FW_ms_acc_trial_acc" %in% names(sub_G)) 
                                    sub_G$FW_ms_acc_trial_acc[[1]] else NA)
    dfsum_M[row_counter,] <- list(sub_M$Sub[[1]],
                                  "ManEst",
                                  sub_M$ManEst_ms_acc_trial_acc[[1]],
                                  if ("G12ManEst_ms_acc_trial_acc" %in% names(sub_M)) 
                                    sub_M$G12ManEst_ms_acc_trial_acc[[1]] else NA,
                                  if ("FW_ms_acc_trial_acc" %in% names(sub_M)) 
                                    sub_M$FW_ms_acc_trial_acc[[1]] else NA)
    dfsum_P[row_counter,] <- list(sub_P$Sub[[1]],
                                  "Perc",
                                  sub_P$Accuracy_acc[[1]],
                                  sub_P$d_prime[[1]])
    if(!is_seminar){
      dfsum_E[row_counter,] <- list(sub_E$Sub[[1]],
                                    "Control",
                                    sub_E$Accuracy_acc[[1]],
                                    sub_E$d_prime[[1]])
    }
    
    
    row_counter <- row_counter + 1
    
    data_G <- rbind(data_G, sub_G)
    data_M <- rbind(data_M, sub_M)
    data_P <- rbind(data_P, sub_P)
    if(!is_seminar){
      data_E <- rbind(data_E, sub_E)
    }
  }
  
  if(TRUE) {
    cat("Grasp Accuracies \n")
    print((dfsum_G))
    cat("ManEst Accuracies \n")
    print((dfsum_M))
    cat("Perc Accuracies \n")
    print((dfsum_P))
    if(!is_seminar){ 
      cat("ExPerc Accuracies \n")
      print((dfsum_E))
    }
  }
  
  if(!is_seminar){
    dfsums <- list(dfsum_G, dfsum_M, dfsum_P, dfsum_E)
    datas <- list(data_G, data_M, data_P, data_E)
  }
  else if(is_seminar){
    dfsums <- list(dfsum_G, dfsum_M, dfsum_P)
    datas <- list(data_G, data_M, data_P)
  }
  
  return(list(dfsums, datas, num_subs))
  # note: [[1]] has summary dfs per task [[1]][[x]] and [[2]] has full dfs per task
}


