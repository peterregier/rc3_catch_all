


# 1. Setup ---------------------------------------------------------------------

## Load packages
require(pacman)
p_load(tidyverse, #keep it tidy
       raster, # work with rasters, NOTE: masks dplyr::select
       janitor, # clean_names()
       ggthemes, # theme_map()
       ggsflabel, # add labels to sf objects
       ggnewscale, # set multiple color scales
       ggspatial, # add north arrow and scale bar
       nhdplusTools, # get watershed boundary/flowlines
       elevatr, # pull elevation maps
       sf) # tidy spatial

## Set common coordinate reference system
common_crs = 4326


# Pull in datasets 

sites <- read_csv("data/final_sites_5.5.2023_MEB.csv") %>% 
  clean_names()

gauges <- read_csv("data/active_gauge_station_YRB_2022.csv") %>% 
  clean_names() %>% 
  rename("site_id" = station_id) %>% 
  mutate(type = "Gauge")

df <- bind_rows(sites %>% dplyr::select(site_id, type, long, lat), 
                gauges %>% dplyr::select(site_id, type, long, lat)) %>% 
  st_as_sf(coords = c("long", "lat"), crs = common_crs)


# 5. Pull NHD data -------------------------------------------------------------

huc <- get_huc(AOI = sites %>% slice(1), type = "huc04")

flowlines <- get_nhdplus(AOI = huc)

ggplot() + 
  geom_sf(data = huc, fill = NA) +
  geom_sf(data = flowlines, color = "lightblue") + 
  geom_sf(data = flowlines %>% filter(grepl("Yakima", gnis_name)), color = "blue") + 
  geom_sf(data = df, aes(color = type), size = 4) + 
  geom_sf_label_repel(data = df, aes(label = site_id, color = type), show.legend = F) +
  scale_color_manual(values = c("red", "black", "blue")) +
  theme_map()

ggsave("figures/230505_final_sites_all_gauges.png", width = 8, height = 10)


