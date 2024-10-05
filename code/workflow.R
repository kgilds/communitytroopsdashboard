library(communitytroopsdashboard)
library(dplyr)
library(pointblank)
library(readr)
library(testthat)


raw_data <- communitytroopsdashboard::create_raw("2024-09-21")



grants_24 <- unique(raw_data$grant)
usethis::use_data(grants_24, overwrite = TRUE)



raw_data$site <- as.character(raw_data$site)  #fixe issue #123 was returning NA values prior


al <-
  action_levels(
    warn_at = 1
  )


inital_outreach <-
  create_agent(
    tbl = raw_data,
    tbl_name = "Raw Download",
    actions = al
  ) %>%
  pointblank::rows_distinct(vars(girl_code, site, time), actions =  pointblank::warn_on_fail()) %>%
  col_vals_not_null(vars(grant, girl_code, time, site)) %>%
  interrogate()




# Create Program ----------------------------------------------------------

program_data_24 <- create_program(raw_data)

### Get Pre Program Data
program_pre_a <- create_program_dat(program_data_24, "Pre")

usethis::use_data(program_pre_a, overwrite = TRUE)





### Get Post Program Data

program_post_a <- create_program_dat(program_data_24, "Post")

usethis::use_data(program_post_a, overwrite = TRUE)




# Question-Responses ------------------------------------------------------

outcome_survey_responses_a <- get_outcome_question_df(program_data_24)

usethis::use_data(outcome_survey_responses_a, overwrite = TRUE)


outcome_survey_q_agent <-
  create_agent(
    tbl = outcome_survey_responses_a,
    tbl_name = "Outcome Survey Responses",
    actions = al
  ) %>%
  pointblank::rows_distinct(vars(girl_code, site, time)) %>%
  col_vals_not_null(vars(grant, girl_code, time, site)) %>%
  interrogate()



# get process questions ---------------------------------------------------

process_survey_responses_a <- get_process_question_df(program_data_24)

usethis::use_data(process_survey_responses_a, overwrite = TRUE)



# Outcome Levels ----------------------------------------------------------



program_level_pre_a <- create_levels(program_pre_a)

pre_level_agent <-
  create_agent(
    tbl = program_level_pre_a,
    tbl_name = "Program Pre Levels",
    actions = al
  ) %>%
  col_vals_in_set(vars(result), set = c("Low", "Medium", "High", "DQ")) %>%
  col_vals_not_null(vars(grant, girl_code, time, site)) %>%
  interrogate()


usethis::use_data(program_level_pre_a, overwrite = TRUE)

program_level_post_a <- create_levels(program_post_a)

usethis::use_data(program_level_post_a, overwrite = TRUE)







# Summary Stats -----------------------------------------------------------



stats_pre_a <- create_summary(program_pre_a)



pre_stats_agent <-
  create_agent(
    tbl = stats_pre_a,
    tbl_name = "Program Stats",
    actions = al
  ) %>%
  col_vals_not_null(vars(girl_code, grant, time, site)) %>%
  ##expect_col_is_numeric(vars(girl_led_mean,
  #cooperative_learning_mean,
  #learning_by_doing_mean,
  #learning_by_reflection_mean,
  #learning_by_doing_mean)) %>%
  interrogate()

usethis::use_data(stats_pre_a, overwrite = TRUE)


stats_post_a <- create_summary(program_post_a)

post_stats_agent <-
  create_agent(
    tbl = stats_post_a,
    tbl_name = "Program Stats",
    actions = al
  ) %>%
  col_vals_not_null(vars(girl_code, grant, time, site)) %>%
  ##expect_col_is_numeric(vars(girl_led_mean,
  #cooperative_learning_mean,
  #learning_by_doing_mean,
  #learning_by_reflection_mean,
  #learning_by_doing_mean)) %>%
  interrogate()


post_stats_agent

usethis::use_data(stats_post_a, overwrite = TRUE)

# Process Results ---------------------------------------------------------



# result_matches_25 <- gs_join(stats_pre_a, stats_post_a)
#
# usethis::use_data(result_matches_25, overwrite = TRUE)
#
# ss <- gs_join(stats_pre_a, stats_post_a) %>%
#   gswcf::outcome_change(pre_ss, post_ss)%>%
#   gswcf::results_long("Sense of Self")
#
# pv <- gs_join(stats_pre_a, stats_post_a) %>%
#   gswcf::outcome_change(pre_pv, post_pv) %>%
#   gswcf::results_long("Positive Values")
#
#
# hr <- gs_join(stats_pre_a, stats_post_a) %>%
#   gswcf::outcome_change(pre_hr, post_hr) %>%
#   gswcf::results_long("Healthy Relationships")
#
#
# cs <- gs_join(stats_pre_a, stats_post_a) %>%
#   gswcf::outcome_change(pre_cs, post_cs) %>%
#   gswcf::results_long("Challenge Seeking")
#
# cp <- gs_join(stats_pre_a, stats_post_a) %>%
#   gswcf::outcome_change(pre_cp, post_cp) %>%
#   gswcf::results_long("Community Problem Solving")
#
# matched_results_24 <- rbind(ss, pv, hr, cs, cp) #%>%
# #deidentifyr::deidentify(girl_code, drop = FALSE)
#
#
#
# qualified_matches_24 <- matched_results_24 %>%
#   group_by(outcome) %>%
#   tally()
#
#
#
# results_stats_24 <- matched_results_24 %>% #updated
#   dplyr::group_by(outcome) %>%
#   skimr::skim() %>%
#   skimr::partition()
#
#
# results_list <- results_stats_24$numeric #updated
#
#
# results_list %>%
#   dplyr::filter(skim_variable == "change") %>%
#   dplyr::select(-skim_variable, -outcome, -n_missing, -complete_rate)
#
#
#
#
#
#
#
#
# process_stats_pre <- create_process_summary(program_pre_a)
#
#
#
# pre_process_stats_agent <-
#   create_agent(
#     tbl = process_stats_pre,
#     tbl_name = "Pre Process Program Stats",
#     actions = al
#   ) %>%
#   col_vals_not_null(vars(girl_code, grant, time, site)) %>%
#
#   interrogate()
#
# pre_process_stats_agent
#
#
# usethis::use_data(process_stats_pre, overwrite = TRUE)
#
# process_stats_post <- create_process_summary(program_post_a)
#
# post_process_stats_agent <-
#   create_agent(
#     tbl = process_stats_post,
#     tbl_name = "Post Process Program Stats",
#     actions = al
#   ) %>%
#   col_vals_not_null(vars(girl_code, grant, time, site)) %>%
#   ##expect_col_is_numeric(vars(girl_led_mean,
#   #cooperative_learning_mean,
#   #learning_by_doing_mean,
#   #learning_by_reflection_mean,
#   #learning_by_doing_mean)) %>%
#   interrogate()
#
#
# #post_proocess_stats_agent
#
# usethis::use_data(process_stats_post, overwrite = TRUE)
#
#
# # Join the Data Frames ----------------------------------------------------
# # Inner join the pre and post process stats data frames by 'girl_code' column,
# # then rename columns for clarity and remove '.x' and '.y' suffixes.
# process_results <- dplyr::inner_join(process_stats_pre, process_stats_post, by = "girl_code") %>%
#   dplyr::rename(grant = grant.x,
#                 site = site.x,
#                 pre_gl = girl_led_mean.x,
#                 post_gl = girl_led_mean.y,
#                 pre_cl = cooperative_learning_mean.x,
#                 post_cl = cooperative_learning_mean.y,
#                 pre_lda = learning_by_doing_action_mean.x,
#                 post_lda = learning_by_doing_action_mean.y,
#                 pre_ldr = learning_by_doing_reflection_mean.x,
#                 post_ldr = learning_by_doing_reflection_mean.y,
#                 pre_ld = learning_by_doing_mean.x,
#                 post_ld = learning_by_doing_mean.y
#   ) %>%
#   dplyr::select(-contains(".x"), -contains(".y"))


# # create-outcome-change ---------------------------------------------------
# # Calculate outcome change for different variables: Girl Led, Cooperative Learning,
# # Learning by Doing, Learning by Doing Action, and Learning by Doing Reflection.
# # Then, convert results to long format.
#
# gl <-
#   gswcf::outcome_change(process_results, pre_gl, post_gl) %>%
#   gswcf::results_long("Girl Led")
#
# cl <-
#   gswcf::outcome_change(process_results, pre_cl, post_cl) %>%
#   gswcf::results_long("Cooperative Learning")
#
# ld <-
#   gswcf::outcome_change(process_results, pre_ld, post_ld) %>%
#   gswcf::results_long("Learning by Doing")
#
# lda <-
#   gswcf::outcome_change(process_results, pre_lda, post_lda) %>%
#   gswcf::results_long("Learning by Doing Action")
#
# ldr <-
#   gswcf::outcome_change(process_results, pre_ldr, post_ldr) %>%
#   gswcf::results_long("Learning by Doing Reflection")
#
# # Combine the outcome change results into a single data frame and de-identify the 'girl_code' column.
# matched_process_results_24 <- rbind(gl, cl, ld, lda, ldr)
#
#
# ### Put in data here
#
# ### Qualified Matches
#
# qualified_process_matches_24 <- matched_process_results_24 %>%
#   group_by(outcome) %>%
#   tally()
#
#
# # Summarize the data for each outcome using skimr package.
# results_process_stats_24 <- matched_process_results_24 %>% #updated
#   dplyr::group_by(outcome) %>%
#   skimr::skim() %>%
#   skimr::partition()
#
# # Extract numeric summary statistics for each outcome.
# process_results_list_24 <- results_process_stats_24$numeric #updated
#
#
# # Filter and select relevant columns from the numeric summary statistics.
# process_results_list_24 %>%
#   dplyr::filter(skim_variable == "change") %>%
#   dplyr::select(-skim_variable, -outcome, -n_missing, -complete_rate)
#
#
#
# # Combine Process and Outcome ---------------------------------------------
#
# #Combine Qualified Matches
# qualified_matches <- rbind(qualified_matches_24, qualified_process_matches_24)
#
# usethis::use_data(qualified_matches_24, overwrite = TRUE)
#
# ## Combine Results
#
# matched_results_24 <- rbind(matched_process_results_24, matched_results_24)
#
# usethis::use_data(matched_results_24, overwrite = TRUE)
#
#
# results_lists <- rbind(results_list, process_results_list_24) %>%
#   dplyr::filter(skim_variable == "change")
#
#
# usethis::use_data(results_list, overwrite = TRUE)
