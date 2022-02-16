# College_Scorecard_US
-- Hello! ✋
Welcome to one of my very first projects 🥳

# Dataset 📎
I took the Data for this project from the U.S. Department of Education.

The Dataset is publicly open for everyone under this link https://data.ed.gov/dataset/college-scorecard-all-data-files/resources

I personally decided to only use the three most recent years of data (2018-2020).

# Prework
To be able to start running queries on the dataset, I first had to transform the Excel Workbooks into a SQL DB.

This seemed quite easily at first; However the only way I found to accomplish this, was by using MSSQL instead of PgAdmin4, which was initially my preferred option.

I therefore, had to become comfortable using MSSQL, the Import/Export tool and eventually SQL Server.

As you may have guessed, I did learn Postgres Syntax first and although there are only a few differences, those differences can be huge (Ex. Window Functions)

Apart from creating a DB in a software I had never used before, I also had to clean up the data... Most of the numeric variables were considered character variables, so I used Excel's Power Query tool to transform all missing data pieces and change the datatype around. I know I could have also used SQL directly, but because I had to go through the dataset anyway, I decided to use Power Query instead.

# Softwares Used 💻
Except for MSSQ and Excel, I pretty much only used Azure Data Studio.

I must say that it was very pleasant to use this tool... Although there are some restrictions on compatibility that could be solved :(



# 
The File is a SQL file that contains all the queries I created, which start at the very basics and deep dive into more and more complex queries.

I hope you enjoy it. 👾
