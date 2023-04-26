## Create updated metadata for sites, including identifying which sites were involved
## in which fire, and potentially burn severity
##
## 2023-04-25
## Peter Regier
##
# ########## #
# ########## #


# 1. Setup ---------------------------------------------------------------------

## Load packages
require(pacman)
p_load(tidyverse, 
       sf, 
       raster, 
       janitor,
       ggsflabel, 
       plotly,
       tmaptools, #crop_shape
       cowplot)

## Set common crs
common_crs = 4326

# 2. Load in site mapping files and reformat -----------------------------------

## Load 2021 sites
ss21_igsns <- read_csv("data/SFA_SpatialStudy_2021_SampleData/SPS_Sample_IGSN-Mapping.csv", skip = 1) %>% 
  clean_names() %>% 
  rename("site_id" = locality) %>% 
  dplyr::select(sample_name, site_id, latitude, longitude)

## Load 2022 sites
ss22_igsns <- read_csv("data/SSS_Data_Package/SSS_Metadata_IGSN-Mapping.csv", skip = 1) %>% 
  clean_names() %>% 
  rename("site_id" = locality) %>% 
  dplyr::select(sample_name, site_id, latitude, longitude)

igsns <- bind_rows(ss21_igsns %>% mutate(study = "ss21"), 
                   ss22_igsns %>% mutate(study = "ss22"))

## Convert to sf object
igsns_sf <- st_as_sf(igsns, coords = c("longitude", "latitude"), crs = common_crs)

write_csv(igsns, "data/230426_igsns_matched_w_sites.csv")


# 3. Load in fire shapefiles ---------------------------------------------------

## Two fires: Evans Canyon burned in 2020 and is available from MTBS. Scheinder
## Springs burned 2021, and isn't up on MTBS yet, so using shapefiles downloaded
## from https://pnnl.sharepoint.com/teams/RC-3RiverCorridorSFA/Shared%20Documents/Forms/AllItems.aspx?ct=1682382215421&or=Teams%2DHL&ga=1&id=%2Fteams%2FRC%2D3RiverCorridorSFA%2FShared%20Documents%2FField%20Logistics%2FShapefiles%2C%20Coordinates%2C%20and%20Maps&viewid=891a5894%2Ddc35%2D4c1f%2D8df7%2D29cc95bd4d85

## Load Evans Canyon boundary
ec_boundary <- read_sf("data/mtbs/wa4685412079920200831/wa4685412079920200831_20200830_20200909_burn_bndy.shp") %>% 
  st_transform(common_crs)

## bound sites to fire boundary
ec_sites <- crop_shape(igsns_sf, ec_boundary, polygon = T)


## Load Schneider Springs boundary
ss_boundary <- read_sf("data/schneider_shapefiles/20211005_Schneider Springs_IR_Shapefiles/20211004_1950_SchneiderSprings_HeatPerimeter.shp") %>% 
  st_transform(common_crs)

# 4. Visualize which sites should overlap --------------------------------------



ggplotly(ggplot() + 
  geom_sf(data = ss_boundary, fill = "lightblue") + 
  geom_sf(data = igsns_sf, aes(color = site_id, shape = study)))


