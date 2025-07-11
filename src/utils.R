## data load funcs
# load multiple files
read_multi_files <- function(data_dir, filenames) {
  data_list <- lapply(filenames, function(filename) {
    read.table(paste0(data_dir, filename), header = TRUE, sep = "", stringsAsFactors = FALSE)
  })
  
  return(data_list)
}

# load questionnaire
read_prepro_csv <- function(data_dir) {
  csv <- read_excel(paste0(data_dir, "participant_questionnaire_answers.xlsx"))
  df_csv <- as.data.frame(csv)
  df_csv$est <- lapply(df_csv$`General Sizes clean`, function(x) as.numeric(unlist(strsplit(x, ",\\s*"))))

  return(df_csv)
}

## toggle for seminar / main data
get_seminar_optionally <- function(is_seminar, option, seminar_option){  
  if(!is_seminar) {
    chosen <- option
  }
  else {
    chosen <- seminar_option
  }
  return(chosen)
}

# set various variables
set_vars_seminar_main <- function(w_dir, is_seminar) {
  folder <- get_seminar_optionally(is_seminar, "main/", "seminar/")
  data_dir <- paste0(w_dir, "/data/", folder)
  files <- list.files(data_dir)
  
  task_num <- get_seminar_optionally(is_seminar, 4, 3)
  coll_participants <- get_seminar_optionally(is_seminar, 
                                              collected_participants, 
                                              collected_participants_seminar)
  task_abbrevs <- get_seminar_optionally(is_seminar, task_abbrevs, task_abbrevs_seminar)
  study_string <- get_seminar_optionally(is_seminar, "main", "pilot")
  
  return(list(folder = folder,
              data_dir = data_dir,
              files = files,
              task_num = task_num,
              coll_participants = coll_participants,
              task_abbrevs = task_abbrevs,
              study_string = study_string))
}

## error check functions
# check if over limit errors were made in a task by participants
get_viable_participants <- function(limit, is_seminar, data, vars) {
  error_participants <- c()
  all_error_participants <- c()
  
  for (i in 1:vars$task_num) {
    error_participants <- data[[i]][data[[i]]["Errors"] > limit,]
    all_error_participants <- c(all_error_participants, error_participants["Sub"]$Sub)
  }
  unique_error_participants <- unique(all_error_participants)
  
  # remove participants with over limit errors
  viable_participants <- vars$coll_participants [! vars$coll_participants %in% unique_error_participants]
  
  print(paste("removed error participants: ", paste(unique_error_participants, collapse = ", ")))
  print(paste("       viable participants: ", paste(viable_participants, collapse = ", ")))
  print(paste(" total viable participants:  ", length(viable_participants)))
  
  return(viable_participants)
}

get_acc <- function(df, value, resp) {
  # resp = c(true_value, false_value)
  
  curr_cacc_subj <- paste0(value, "_acc")
  
  correct <- sum(df[[value]] == resp[1])
  total <-  sum(df[[value]] == resp[1] | df[[value]] == resp[2])
  acc <- correct/total
  
  df[[curr_cacc_subj]] <- acc
  
  return(df)
}

## print functions
print_quickcheck <- function(df, value) {
  # "clean" stimuli column
  # need double [[]] here cause otherwise it sees it as a vec c("D1A", ...)
  df$disc_sizes <- substr(df[[stim_col]], 1, 2)
  
  # calc mean, sem, median
  # need the vec version here so it's same length
  checks_per_stimuli <- aggregate(df[value], df[stim_col], 
                                  FUN = function(x) c(Mean = mean(x), 
                                                      SEM = sem(x), 
                                                      Median = median(x)))
  checks_per_stimuli <- do.call(data.frame, checks_per_stimuli)
  
  # calc mean, sem, median with "clean" equal stimuli
  checks_per_size <- aggregate(df[value], list(Stimuli = df$disc_sizes), 
                               FUN = function(x) c(Mean = mean(x), 
                                                   SEM = sem(x), 
                                                   Median = median(x)))
  checks_per_size <- do.call(data.frame, checks_per_size)
  
  # append both versions
  overview <- rbind(checks_per_stimuli, checks_per_size)
  colnames(overview) <- c("Stimuli", "Mean", "SEM", "Median")
  
  # give title and print
  cat(paste(value, "Overview \n"))
  print(overview)
}

print_accuracy <- function(df, col) {
  df <- get_acc(df, col, c("C", "F"))
  new_col <- paste0(col, "_acc")
  
  cat("Perc Overview \n")
  print(df[new_col][[1]][1])
}