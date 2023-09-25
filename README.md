# Online Retail Analysis 

![](online-shopping-concept.jpg)
---
## Introduction
Welcome to my first project portfolio! In this portfolio, I am excited to present my work on a SQL and Power BI project focused on analyzing online retail data for a UK-based non-store online retailer. The dataset comprises transactions recorded between December 1, 2010, and December 9, 2011. The retailer specializes in selling unique gifts suitable for various occasions, with a significant portion of its customer base consisting of wholesalers.

## Project Objectives:
The primary objectives of this analysis are as follows:
- To gain valuable insights into the retail operations, customer behavior, and sales trends,
- To answer key questions and provide data-driven recommendations for decision-makers,
- To showcase the capabilities of SQL and Power BI in extracting insights from real-world retail data.

**_Disclaimer:_**
_It is important to note that this report is solely intended to demonstrate the capabilities of SQL and Power BI for data analysis and does not represent any specific company or organization._

## Dataset Source:
The dataset used for this project is in CSV format and can be accessed on Kaggle at the following link [here](https://www.kaggle.com/datasets/ulrikthygepedersen/online-retail-dataset). This is a table containing transaction records for a specific period and serves as the main data source for analysis.

## Methods Employed
For this project, I employed a combination of SQL and Power BI for data analysis:

- SQL was used for data cleaning, transformation, and aggregation.
- Power BI was utilized to create interactive and informative visualizations.

## Data Cleaning and Preprocessing
The dataset underwent comprehensive data cleaning and preprocessing steps, including:

- Addressing NULL values.
- Data type conversions.
- Deleting Irrelevant Rows
- Creat additional columns 
- Dealing with duplicate rows in the dataset.

The SQL script used for data cleaning and preprocessing can be found ![here](Online_Retail.sql)

## Visualization

Our interactive Power BI dashboard features a range of visualizations, including:
- Total Sales
- Customer Count
- Number of Transactions
- Average Order Value
- Total Sales by Month
- Customers by Country
- Total Sales by Country
- Transaction Status Distribution (%)
- Top 5 Selling Products by Quantity
- Transaction Trends by Day and Time

![](Online_Retail_Dashboard.jpg)

## Analysis and Insights

Total Sales Amount Over the Specified Period: The analysis revealed that the total sales amount for the period between December 1, 2010, and December 9, 2011, amounted to $10.9M. This metric serves as a critical indicator of the retailer's overall revenue during this time frame.

Count of Distinct Customers (Excluding Cancellations): By excluding cancellations, the analysis determined that there were 4339 distinct customers who engaged with the retailer during the specified period. This metric provides insights into the retailer's customer base and the number of unique individuals or businesses making purchases.

Number of Unique Transactions: The dataset contained a total of 19959 unique transactions. This metric quantifies the volume of individual sales interactions, offering insights into the retailer's transactional activity.

Average Order Value (Excluding Cancellations): The average order value, calculated by excluding cancellations, was $533. This metric indicates the typical amount spent by customers in a single transaction, which is valuable for assessing purchasing behavior.

Monthly Sales Trends: The analysis uncovered distinct monthly sales trends, with November 2011 being the highest and February 2011 the lowest. These trends help identify seasonality or patterns in sales, which can inform inventory management and marketing strategies.

Customer Segmentation by Country: The analysis segmented customers by their respective countries, revealing that United Kingdom had the highest number of customers. This segmentation assists in understanding the retailer's international customer distribution.

Top-Selling Products by Quantity: The analysis identified the top-selling products based on quantity sold, with "Paper Craft, Little  Birdie" being the best-seller. Understanding which products are in high demand can guide inventory and marketing decisions.

Transaction Status Distribution: The distribution of transaction statuses showed that 98.27% of transactions were successful, while 1.73% were cancellations. This insight provides an overview of transaction outcomes.

Transaction Trends by Day and Time: The analysis revealed transaction trends based on the day of the week and time of day. For instance, on Thursday and at 12 o'clock, which can inform staffing and operational decisions.

--------------
Analyze transaction trends by both day of the week and time of the day.showing the number of transactions for each day of the week and hour of the day, excluding cancellations. You can analyze this data to identify patterns and peak transaction times during the week.

total sales by month ,showcase how sales have evolved throughout the year. This information can be invaluable for business decision-making, such as identifying peak sales periods, evaluating the effectiveness of marketing campaigns, and forecasting future sales based on historical trends.total sales amounts for each month, which is valuable for analyzing sales trends over time.

