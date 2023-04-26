## First looks at 2021 Spatial Study respiration data
##
## Peter Regier
## 2023-03-16
##
# ########### #
# ########### #

# 1. Setup --------------

require(pacman)
p_load(tidyverse,
       googlesheets4,
       janitor)

theme_set(theme_bw())


# 2. Read respiration data ----------

df <- read_csv("data/SFA_SpatialStudy_2021_SensorData_v2/MinidotManualChamber/Plots_and_Summary_Statistics/Minidot_Summary_Statistics_v2.csv", 
               skip = 48) %>% 
  clean_names()

resp_avg <- df %>% 
  rowwise() %>% 
  mutate(do_slope = mean(dissolved_oxygen_1_slope, dissolved_oxygen_2_slope, dissolved_oxygen_3_slope)) %>% 
  select(site_id, do_slope)

ggplot(resp_avg, aes(site_id, do_slope)) + geom_point()


# 3. Read in other RC data ---------

sonde <- read_sheet("https://docs.google.com/spreadsheets/d/1LC2kgUGlYfvOpqrQP3Ws9KJeeemtDjLwKymqaQVxPVQ/edit#gid=545227231")

