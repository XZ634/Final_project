library(tidyverse)
library(sf)
library(readxl)
library(patchwork)
library(readr)

f860_path <- "data/eia8602021/2___Plant_Y2021.xlsx"
f860 <- read_excel(f860_path,skip=1) %>% 
  janitor::clean_names()

f923_path <- "data/f923_2021/EIA923_Schedules_2_3_4_5_M_12_2021_Final_Revision.xlsx"
f923 <- read_excel(f923_path,sheet = 1,skip = 5) %>% 
  janitor::clean_names()

plants <- f860 %>%
  select(plant_code,county, state,latitude, longitude)

generation <- f923 %>% 
  mutate(plant_code = plant_id) %>% 
  select(plant_code, plant_name, aer_fuel_type_code,net_generation_megawatthours) %>% 
  filter(aer_fuel_type_code %in% c("SUN","GEO","HPS","HYC","MLG","ORW","WND","WWW"),
         )

###机组 地理信息 发电类型 发电量
rw <- left_join(x=generation,y=plants,by="plant_code") %>% 
  filter(
    !is.na(longitude),
    !is.na(latitude),
    !(state %in% c("PR","GU","MP","VI","HI","AK","AS"))
    ) %>% 
  st_as_sf(coords = c("longitude","latitude")) %>% 
  st_set_crs(4326)

### 两个地图和其他地理信息
state_shp_path <- "data/tl_2023_us_state/tl_2023_us_state.shp"
state_geo <- read_sf(state_shp_path) %>% 
  janitor::clean_names()%>% 
  select(statefp,stusps,name,geometry) %>% 
  st_transform(4326)

county_shp_path <- "data/tl_2021_us_county/tl_2021_us_county.shp"
county_geo <- read_sf(county_shp_path) %>%
  janitor::clean_names() %>% 
  select(statefp,countyfp,geoid,name,namelsad,geometry) %>% 
  st_transform(4326)


###county generation
plant_cty <- st_join(county_geo,rw) %>% 
  filter(!(statefp %in% c("72","66","69","78","15","02","60"))) %>% 
  mutate(
  net_generation_megawatthours = if_else(
    is.na(net_generation_megawatthours),0,net_generation_megawatthours)
)

plant_cty %>% 
  group_by(geometry) %>% 
  summarise(cty_generation = sum(net_generation_megawatthours)) %>% 
  ggplot()+
  geom_sf(aes(fill=cty_generation))+
  scale_fill_gradient(
    low = "green",
    high = "darkgreen"
  )+
  labs(
    title = "Net renewable electricity generation by county"
  )+
  theme_void()

###state generation
plant_state <- st_join(state_geo,rw) %>% 
  filter(!(stusps %in% c("PR","GU","MP","VI","HI","AK","AS"))) %>% 
  mutate(
    net_generation_megawatthours = if_else(
      is.na(net_generation_megawatthours),0,net_generation_megawatthours)
  )

plant_state %>% 
  group_by(geometry) %>% 
  summarise(state_generation = sum(net_generation_megawatthours)) %>% 
  ggplot()+
  geom_sf(aes(fill=state_generation))+
  scale_fill_gradient(
    low = "skyblue",
    high = "blue"
  )+
  geom_sf(data=rw,size=0.3,color="yellow")+
  labs(
    title = "Net renewable electricity generation by state"
  )+
  theme_void()

### combine data ------------
## prepare data
state_nogeo <- state_geo %>% 
  st_drop_geometry()

county_nogeo <- county_geo %>% 
  st_drop_geometry()

state_cty <- left_join(
  state_nogeo,
  county_nogeo,
  by = "statefp"
) ### state and county info


### generation by county
cty_generation <- plant_cty %>% 
  st_drop_geometry() %>% 
  group_by(geoid) %>% 
  summarise(cty_generation = sum(net_generation_megawatthours))

# load in urban and aqi
urban_path <- "data/urban.csv"
urban <- read_csv(urban_path) %>% 
  select(-1,-2)

aqi_path <- "data/aqi.csv"
aqi <- read_csv(aqi_path) %>% 
  select(-1,-4)

# combine!
## combine generation and state & county info
state_cty_fulldata <- left_join(
  cty_generation,
  state_cty,
  by = "geoid"
)

## add in urban
state_cty_fulldata <- left_join(
  state_cty_fulldata,
  urban,
  by = c("stusps"="abb", "name.y"="county")
)

## add in aqi
state_cty_fulldata <- left_join(
  state_cty_fulldata,
  aqi,
  by = c("name.x"="State", "name.y"="County")
)

# load in ACS by Xiaorui Shi
##这里用到的all_data_acs来源于Xiaorui Shi的qmd
all_data_acs <- all_data_acs %>% 
  slice(-1) %>% 
  janitor::clean_names()

## add in ACS
state_cty_fulldata <- left_join(
  state_cty_fulldata,
  all_data_acs,
  by = c("geoid"="geo_id")
)




