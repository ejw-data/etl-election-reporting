# etl-election-reporting  

Author:  Erin James Wills, ejw.data@gmail.com

![election polling project banner](./images/election-polling-etl.png)
<cite>Photo by <a href="https://unsplash.com/@eagleboobs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Elliott Stallion</a> on <a href="https://unsplash.com/s/photos/election?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></cite>

<br>

## Overview  
<hr>

Used pandas to resolve discrepencies in real-time election poll results and moved data to postgres. 

<br>

## Technologies  
*  Python
*  PostgreSQL

<br>  

## Data Source  

The dataset was obtained from:  
*  [https://alex.github.io/nyt-2020-election-scraper/all-state-changes.html](https://alex.github.io/nyt-2020-election-scraper/all-state-changes.html)  

**Note**:  The site data may be overwritten during each election.

<br>

## Setup and Installation  
1. Environment needs the following:  
    *  Python 3.6+  
    *  numpy
    *  pandas
1. Activate your environment
1. Clone the repo to your local machine
1. Start Jupyter Notebook within the environment from the repo
1. To run `election_data_extract.ipynb`  
1. The above notebook produces a cleaned dataframe called `db_file.csv` inside the `data` folder.
1. Open pgAdmin and create a database named `uselections`
1. The .sql files can be found in the `sql` folder
1. Open a query tool and run the `vote_counts_schema.sql` query to create the main table named `vote_counts`.
1. In another query tool, run `create_margin_table.sql` to generate the `margin_info` table which manipulates and summarizes the `vote_counts` table.
1. Examples of queries can be found in `queries.sql` and `summary.sql`.
1. The `create_margin_view.sql` is a method of creating `margin_info` table as a view but I prefer using the above method instead.  
 

<br>
