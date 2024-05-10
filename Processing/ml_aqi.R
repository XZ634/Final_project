library(tidyverse)
library(tidymodels)
library(recipes)
library(vip) 
library(patchwork)

combined<-read_csv("data/combined_dta.csv")

set.seed(20240509)
combined<-combined %>% 
  filter(!is.na(Median.AQI))

split<-initial_split(combined)
aqi_train<-training(split)
aqi_test<-testing(split)

## create recipe
aqi_rec<-recipe(Median.AQI~ Days.with.AQI + total_pop_25 + b_aor_higher_pop_25 +
                  percent_b_aor_higher + mean_income + total_pop_comm + total_car +
                  total_eco + heat_sum + green_heat_sum + fuel_heat_sum + ecoheat +
                  fuelheat + station_count + code_2013, 
                data=aqi_train) %>% 
  step_filter_missing(all_predictors()) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_impute_median(all_numeric_predictors(), all_nominal_predictors())

## set grid & fold
penalty_param <- penalty()
lasso_grid <- grid_regular(penalty_param, levels = 10)

aqi_cv<-vfold_cv(aqi_train, v=10, strata= Median.AQI)

## create mod
lasso_mod<-linear_reg(penalty=tune(),mixture=1) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

lasso_wf<-workflow() %>% 
  add_recipe(aqi_rec) %>% 
  add_model(lasso_mod)

lasso_res<-lasso_wf %>% 
  tune_grid(resample=aqi_cv,
            grid=lasso_grid,
            metrics=metric_set(mae,rmse))

lasso_res %>% 
  collect_metrics(summarize=F) %>% 
  filter(.metric=="rmse") %>% 
  ggplot(aes(x=id,y=.estimate, group=penalty, color=penalty),alpha=0.5)+
  geom_line()+
  geom_point()+
  theme_minimal()

## evaluate model 
lasso_best<-lasso_res %>%
  select_best(metric="rmse")

lasso_final<-finalize_workflow(
  lasso_wf,
  parameters=lasso_best) %>% 
  fit(data=aqi_train)

predictions<-bind_cols(
  aqi_test,
  predict(object=lasso_final,new_data=aqi_test))

rmse(data=predictions,truth=Median.AQI,estimate=.pred)

lasso_final %>%
  extract_fit_parsnip() %>%
  vip(num_features = 10)

## visualization and comparasion
map1<-st_read("data/tl_2021_us_county/tl_2021_us_county.shp", quiet = TRUE) %>% 
  st_set_crs(4326) %>% 
  select(STATEFP,COUNTYFP, geometry) %>% 
  filter(!(STATEFP %in% c("72","66","69","78","15","02","60")))

plot1<-left_join(predictions,map1,by=c("countyfp"="COUNTYFP","statefp"="STATEFP"),copy=T)

p1<-ggplot()+
  geom_sf(data=map1)+
  geom_sf(data=plot1,aes(fill=Median.AQI, geometry=geometry))+
  labs(title = "Predictions Mapped to Counties")+
  theme_minimal()

plot2<-left_join(aqi_test,map1,by=c("countyfp"="COUNTYFP","statefp"="STATEFP"),copy=T)

p2<-ggplot()+
  geom_sf(data=map1)+
  geom_sf(data=plot2,aes(fill=Median.AQI, geometry=geometry))+
  labs(title="Orginal Mapped to Counties")+
  theme_minimal()

p1+p2

          