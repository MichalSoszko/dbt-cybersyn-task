# Iowa Liquor Sales Case Study

## Data

The state of Iowa publishes liquor sales within the state (CSV file of item-level sales by
store for 2018-2021). Read more about the data on the [Iowa Data Portal](https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy/about_data).

## Questions

Download the Iowa [liquor sales data for 2018-2021](https://drive.google.com/file/d/18IJZGdrAexE1h07myNSM-lBh7Vu55JK4/view). You may use SQL, Python, or R
and any supplementary open-source packages of your choice. Clean, aggregate, and
organize the data sufficiently to answer the following questions:
1. Grouping individual store names together (e.g., all of Walmart, Liquor Barn,
Hy-Vee, etc.), who are the top 10 retailers by year?
a. Grocery store companies have many locations, or individual stores. For
example, Hy-Vee #3 Food & Drugstore / Davenport and Hy-Vee Food
Store / Dubuque are specific locations for the overall retailer, Hy-Vee.
2. What data integrity issues did you discover? How could you (or how did you)
solve/account for these?

    a. Comment on any data issues you discovered and what assumptions you
used to deal with them.

    b. What's a simple solution to solving data quality issues?


## Deliverables
Please share your code (e.g., Python/R files, Jupyter notebook, Hex project (or
similar hosted notebook), or any other materials you found useful) and a PDF
outlining your answers to the above questions (no more than 1 page, please -
visualizations can be attached in an appendix).

# Solution (Bigquery)

## Data sample upload

1. In the GCP project log in to GC Shell and create external table:

```
bq mk --external_table_definition=./iowa_liquor_sales_2018_2021.json@CSV=https://drive.google.com/open?id=18IJZGdrAexE1h07myNSM-lBh7Vu55JK4 external_data_sources.iowa_liquor_sales
```

Use data_upload/iowa_liquor_slaes_2018_2021.json schema file.

The command above will create `iowa_liquor_sales` external table in `external_data_sources` schema in your GCP project. The URI is taken from the gdrive link given in the task description.

2. In Bigquery console execute the following query:

```
create or replace table ingested.raw_iowa_liquor_sales as (

SELECT * FROM `<<gcp_project>>.external_data_sources.iowa_liquor_sales_2018_2021` 

)
```