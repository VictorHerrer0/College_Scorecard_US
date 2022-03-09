# Black Hole of US-Universities
-- Hello! ✋
Welcome to one of my very first projects 🥳

I have always wondered how US-based students decide which university to go for when the time comes... So many of them to choose from and yet, no guarantee of getting accepted in any of them.

That is why in this project I focus on retrieving and exploring a Scorecard dataset, that contains information such as location, admision rate, average cost, etc. for over 6000 universities in the US, to show young students who are about to graduate from high school, that there is a more practical approach towards "College Appplications".
 

As I started exploring the Database I felt like it was asking me to keep digging into it and keep developing my queries. That is where the name of this project comes from.


# Dataset 📎
I took the Data for this project from the U.S. Department of Education.

The Dataset is publicly open for everyone under this link https://data.ed.gov/dataset/college-scorecard-all-data-files/resources

I personally decided to only use the three most recent years of data (2018-2020).


# Prework
To be able to start running queries on the dataset, I first had to transform the Excel Workbooks into a SQL DB.

This seemed quite easily at first; However the only way I found to accomplish this, was by using MSSQL instead of PgAdmin4, which was initially my preferred option.

I therefore, had to become comfortable using MS SQL Server Management Studio, the Import/Export tool and eventually SQL Server.

As you may have guessed, I did learn Postgres Syntax first and although there are only a few differences, those differences can be huge (Ex. Window Functions)

Apart from creating a DB in a software I had never used before, I also had to clean up the data... Most of the numeric variables were considered character variables, so I used Excel's Power Query tool to transform all missing data pieces and change the datatype around. I know I could have also used SQL directly, but because I had to go through the dataset anyway, I decided to use Power Query instead.


# Softwares Used 💻
Except for MSSQ and Excel, I pretty much only used Azure Data Studio.

I must say that it was very pleasant to use this tool... Although there are some restrictions on compatibility that could be solved :(


# 
The File is a SQL file that contains all the queries I created, which start at the very basics and deep dive into more and more complex queries.

I hope you enjoy it. 👾


# Conclusion
Learning is a key part of every project:

I am not joking when I say that I have just found out that indeed SQL is a really powerful tool.
With just a bit of imagination you can get to know a lot about an unknown Database... And look at this, I have only coded 300 lines of SQL queries.

Did you know that the university of Columbia only accepted about 5% of its 150000 applicants in 2020?

Did you know that on top tier universities like Stanford, Harvard or Yale, the loan share for students has decreased more than 5-7% during the last 3 years?

It is not only that, but they actually increased costs as well...

I know this for a fact, because I saw the data, trust me.
