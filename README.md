# Final project review
Xiangming Zeng - xz634, Ruiyang Zhang - rz326, Lingxi Li - ll1188, Xiaorui Shi - xs215

## Research Overview

### Research Question
The increasingly prominent environmental issues pose a significant challenge to human survival. The utilization of new energy sources, including renewable energy generation and the use of new energy vehicles, has highlighted the potential of policy solutions to address these environmental challenges. To what extent can the use of clean energy improve environmental quality? This question drives us to conduct this research.

### Major Datasets

**Air Quality Index Annual Summary Data (2021):** Provided by the U.S. Environmental Protection Agency, we use the proportion of "good days" as a measure of air quality. 

**Alternative Fueling Station Locations (2021):** Provided by The Alternative Fuels Data Center, this dataset includes locations of alternative fueling stations across the U.S..

**Energy Generation – Form EIA-923 (2021):** This dataset captures detailed monthly and annual data on electricity generation at power plants across the U.S.

**Power Plant – Form EIA-860 (2021):** It contains specific information about  electric power plants with significant capacity, including geographic details.

**NCHS Urban-Rural Classification (2013):** This dataset categorizes U.S. counties by urbanization levels.

**DC Public Facilities:** This collection of geospatial data includes locations of public facilities in Washington D.C., such as schools and government buildings.

**American Community Survey (2017-2021):** we use socio-economic,  energy consumption and commuting data from ACS.

## Structure of This Article

Our first two analyses are exploratory. The first one involves visualizing green electricity generation at the county and state levels, while the second one focuses on mapping alternative fueling stations in DC. Then, we conducted data wrangling and exploratory analysis before machine learning. Our two machine learning models are aligned with our research question. The first one is a decision tree model used to predict air quality, while the second one is a Lasso regression model used to predict the number of alternative fueling stations. Both models hold significant policy relevance in the fields of environmental and urban policy.

## Preliminary Findings

To address the first research question, "can the use of clean energy improve environmental quality," we developed a decision tree model. The model exhibits relatively low predictive power (accuracy = 0.681). This could be attributed to the complexity of air quality, as there are numerous factors influencing it. However, alternative fueling stations are among the 10 most important predictors, appearing as the last one, suggesting that the use of new energy vehicles may contribute to predicting air quality, albeit with a moderate correlation. 

Conversely, green electricity generation does not emerge as a significant predictor for air quality.In conclusion, it appears that energy consumption patterns are more influential in predicting air quality than energy production methods. This notion warrants further research.

To provide guidance for future investment in infrastructure for new energy vehicles, we developed a lasso regression model to predict the number of alternative fueling stations. The model performs very well, with an RMSE of 24.4 and a range of 1144. However, since the mean number of alternative fueling stations is only 15.52 (due to most counties not being big cities), this model will be more applicable in large cities where the number of alternative fueling stations is significantly higher.

The key predictors identified are population, utility gas consumption, population with Bachelor’s degrees, and electricity consumption, which align with common sense. What's interesting is that other clean commuting patterns, like public transportation, cycling, motorcycling, and walking, are also important predictors for citizens' demand for alternative fueling stations. The relationship between different transportation preferences deserves further study.

