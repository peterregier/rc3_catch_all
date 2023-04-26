
require(pacman)
  
p_load(sf, 
        tidyverse,
       janitor,
        nhdplusTools)

sites <- read_csv("/Users/regi350/Library/CloudStorage/OneDrive-PNNL/Documents/projects/RC/rc3/data/RC3_All_Site_Details_and_Permit_Status.csv") %>% 
   clean_names() %>% 
   mutate(site = str_sub(site_name_rc3_study_code_site_code, 6, n())) %>% 
  select(lat, long, site, site_description, river_name)

sites_sf <- st_as_sf(sites, coords = c("long", "lat"), crs =  4326)

ggplot() + 
  geom_sf(data = sites_sf %>% filter(river_name == "Wenas Creek"))

huc8 <- get_huc8(AOI = sites_sf %>% filter(river_name == "Wenas Creek"))
flowlines <- get_nhdplus(huc8)

ggplot() + 
  geom_sf(data = huc8) + 
  geom_sf(data = flowlines) + 
  geom_sf(data = sites_sf %>% filter(river_name == "Wenas Creek"))


