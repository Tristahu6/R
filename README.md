# R
# NYC Real Estate Project

## Business Case Analysis: New York City Real Estate

### Problem Statement
A real estate brokerage firm is considering opening a new office in the NYC market, but is faced with the challenge of deciding whether it's a viable decision given the variety of properties and sales trends and which location to invest. The dataset contains 1.76 million entries with transactions for both RESIDENTIAL_UNITS and COMMERCIAL_UNITS in all neighborhoods in NYC.

### Objectives
- Evaluate the service demand in potential neighborhoods.
- Assess the expected growth of the real estate market.
- Determine whether the business can operate profitably with an acceptable level of revenue.
- Develop a sound plan of action and recommendations for whether to open up an office in a chosen neighborhood based on the above factors.

## Project Details

### Dataset
- Property sales in the 5 boroughs of NYC.
- Timeframe: Jan 1, 2003 - Dec 30, 2021.
- 1.76 million entries, 17 variables including Neighborhood, Sales Date, Sales Price.

### Method
- Used R & Excel Solver to conduct Market Clustering & Market trend (descriptive), Sales Forecast (predictive), and Optimization Model (prescriptive) analysis.

### Market Clustering (R)
- **Market Trend:** Clustering analysis revealed that the North-Flushing neighborhood is positioned in Cluster 2: high transaction volumes and relatively low unit prices, suggesting a high demand for real estate services in this area and market stability.
- Comparing North-Flushing to two other neighborhoods in Queens, it has the biggest potential for real estate value increase.

### Sales Forecast (R)
- Used data from 2009 Q1 to build a time series exponential model to predict future sales in North-Flushing until the end of 2023, considering seasonality and trends.
- The results indicate that sales performance is expected to continue to increase for projected years, suggesting continued growth.

### Optimization (Excel Solver)
- **Objective:** To Maximize NPV.
- Established an optimization model using Excel Solver to seek the optimal solution (determining office rent space, number of employees, commission baseline for sales performance) for max NPV, subject to a set of constraints based on key assumptions.
- Constraints:
  - 4% <= penetration rate <= 6%.
  - Office space area >= 250 SQF.
  - 0 <= the employee number (an integer) <= 3.
  - Operating budget/quarter <= $45,000.
- The model estimates an NPV of up to $3,204,473 for the eight-quarter forecast period, with an ROI of 822% achievable by applying the optimal solution.

## Key Benefits
- **Informed Decision-Making:** Provided recommendations based on the findings. Meets the project objective and enables businesses to make informed decisions based on real estate demand trends, reducing the risk of picking the low-demand neighborhood.
- **Increased Sales and Revenue:** Provides insights into customer demand, preferences, and trends, leading to increased sales and revenue for the organization by identifying growth opportunities.
- **Operational Efficiency:** Improves operational efficiency and resource planning (personnel and office cost), reducing costs and increasing profitability and competitiveness.
