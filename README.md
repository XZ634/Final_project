# Final project review
Xiangming Zeng - xz634, Ruiyang Zhang - rz326, Lingxi Li - ll1188, Xiaorui Shi - xs215
## Research Overview
### Background
Faced with increasingly severe environmental issues that pose significant challenges to human survival, the development and utilization of new energy sources, including renewable energy production and the use of new energy vehicles, have emerged as vital policy tools to address these environmental challenges. This study aims to answer a crucial question: To what extent can the use of clean energy improve environmental quality? 

### Major Datasets
To effectively address our research questions on the impacts of new energy technologies on air quality and infrastructure needs, we leverage a selection of diverse and relevant datasets. These sources provide comprehensive data ranging from air quality metrics, energy production details, and geographical distributions of energy infrastructure to demographic insights：

**Air Quality Index Annual Summary Data (2021):** Provided by the U.S. Environmental Protection Agency, uses the proportion of "good days" as a measure of air quality in each U.S. county. 

**Alternative Fueling Station Locations (2021):** Compiled by The Alternative Fuels Data Center, this dataset includes locations of alternative fueling stations across the U.S., reflecting the uptake of new energy vehicles.

**Energy Generation – Form EIA-923 (2021):** This dataset captures detailed monthly and annual data on electricity generation at power plants across the U.S.

**Power Plant – Form EIA-860 (2021):** It contains specific information about generators at electric power plants with significant capacity, including geographic details.

**NCHS Urban-Rural Classification (2013):** This dataset categorizes U.S. counties by urbanization levels, helping contextualize the varying impacts of new energy technologies across different settings.

**DC Public Facilities:** This collection of geospatial data includes locations of public facilities in Washington D.C., such as schools and government buildings.

## Methodological Approach

In our first model, we use a decision tree to explore the potential impacts of the green energy sector on air quality due to their ability to model nonlinear relationships and ease of interpretation. We hypothesize that the green energy sector contributes to improved air quality. Specifically, we randomly select 75% of the data for model training and test on the remaining 25%. The decision tree model has an accuracy of 0.668, with precision and recall rates between 0.7 and 0.8. This model indicates that green power generation is not a key predictor of air quality, whereas the structure of energy consumption and citizens' commuting preferences (including driving and other cleaner modes of transport such as public transit, bicycling, and walking) significantly impact air quality. 

In the second model, we establish a Lasso regression model to predict the number of EV charging stations and to identify the most significant factors affecting the number of alternative fuel stations in cities. Before performing Lasso regression, we choose to remove the variable "good_days_rate" due to having over 2000 missing values. The model uses regularization to select important predictors, showing that population size, the number of households using gas, the proportion of the population with bachelor's degrees, and electricity consumption are the four most significant predictors of the number of alternative fuel stations. The Lasso model's root mean square error (RMSE) is 28, which is small relative to the range of alternative fuel stations.

## Preliminary Findings

Initial results suggest a positive correlation between the proliferation of new energy installations and improvements in air quality, especially in urban settings. Furthermore, the analysis indicates that the presence of public facilities is closely linked to an increased number of EV charging stations, underlining the importance of public infrastructure in supporting the shift towards electric vehicles.

