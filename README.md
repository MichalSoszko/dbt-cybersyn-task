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

To answer the questions included in the task, I created a project in Bigquery and imported the data.

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

## Comments

### dbt project

Most of the data transformations (cleaning, aggregation, column naming adjustment, etc.) were carried out in SQL as part of a classic data pipeline. The exception is the grouping of individual store names, where I used a Python script. The data pipeline has a typical “layered” structure (folders staging, intermediate, marts, reports), where I store models responsible for different stages of data transformation. At an early stage of the project, when I was getting acquainted with the dataset, I used elements of exploratory statistical analysis (EDA folder).

### Answers to questions

Ad. 1. To answer the question, I created the `mart_fact_invoices` table (schema `3_marts`) which is a cleaned version of the source fact table. Based on it, I performed aggregation and ranking, summarized in the `4_reports.report_top_10_retailers_aggy` table.

Ad. 2a During the analysis of the integrity of the source data, I divided the data into fact and dimension tables. It quickly turned out that in the dimension table, which collected information about stores, the data were not consistent. 

- Address data such as - street name, county, or geolocation data could differ from each other (slightly) or sometimes they were missing (nulls). There were situations where one store_number (which should be a primary key) corresponded to several different sets of dimensions. In this case, the store_number lost its uniqueness. Here I decided to extract the most frequently repeating sets of parameters and (assuming that they do not change in the studied period) and assign them per store_number (separately for GEO data and address information).

- Store names (store_name), against which individual outlets should be grouped, differed from each other. In some cases (like for Hy-Vee) it was easy to locate a pattern that allowed to extract the proper name (or part of it) for the retailer. Unfortunately, in many cases simple regexp expressions were not sufficient and it was difficult for me to develop a grouping script in a reasonable time. Here I decided to refer to the NLP model (GPT-3.5), which as part of a primitive script written in Python (folder analyses/match_store_names) generated a dictionary assigning store names to (deduced) retailer names. Then I imported the dictionary into dbt as a csv (after processing).

- Raw Fact data has incomplete invoices - for a very small fraction of data, the number of records per invoice_id was lower than the maximum purchase index on the invoice. This suggests that in their case, sales amounts will be underestimated.

- The sales calculation in a fairly large number of invoices was incorrect ((state_bottle_retail * bottles_sold) != sales__dollars) and required correction.


Ad. 2b Reporting bugs to the data author, hoping he will listen :) But seriously - in my opinion there is no universal way to solve data quality issues. It is necessary to approach individually what type of data it is, where it comes from and consider whether e.g. problems are not the result of a disturbed data ingestion process. If not - missing, nullified values can be tried to be supplemented using external data (dictionaries, available geolocation data etc.) or based on existing records and their frequency of occurrence.
