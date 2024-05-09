library(readxl)

## Clean Urban and Rural classification data set
urban<-read_excel("data/NCHSURCodes2013.xlsx") %>% 
  rename(fips='FIPS code',
         abb='State Abr.',
         code_2013='2013 code',
         county_name='County name') %>% 
  mutate(county = str_replace(county_name, " County", "")) %>% 
  select(fips,abb,county,code_2013)

write.csv(urban,"data/urban.csv")

## Clean AQI data set
aqi<-read.csv("data/annual_aqi_by_county_2021.csv") %>% 
  select(State, County, Year, Days.with.AQI, Median.AQI)

write.csv(aqi,"data/aqi.csv")

## Combine investment data set and visualize
investment1<-read_csv("data/EnergyandIndustryInvestmentAnnouncementLocations2023.csv")
investment2<-read_csv("data/ManufacturingInvestmentAnnouncementLocations2023.csv")
invest<-rbind(investment1,investment2) %>% 
  rename(investment='Investment (Est.)')

invest<-invest%>% 
  st_as_sf(coords=c("Longitude_Jittered","Latitude_Jittered") ,remove=F) %>% 
  st_set_crs(value=4326) %>% 
  filter(Longitude_Jittered>-130)
  
map<-st_read("data/tl_2021_us_county/tl_2021_us_county.shp", quiet = TRUE) %>% 
  st_set_crs(4326) %>% 
  select(STATEFP, geometry) %>% 
  filter(!(STATEFP %in% c("72","66","69","78","15","02","60")))

ggplot()+
  geom_sf(data=map)+
  geom_sf(data=invest, aes(size=investment),color="darkblue",alpha=0.3)+
  theme_void()
  
          