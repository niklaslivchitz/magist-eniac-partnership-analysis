# magist-eniac-partnership-analysis

## Project overview
Analysis of the Magist dataset using SQL and Tableau.
Completed as a data analytics bootcamp project, working in a small group.
Magist is posited as a brazilian E-commerce company.
This is a limited project representing a first exposure to SQL.

## Key questions
- Would magist be a good cooperation partner for a larger Spanish tech company ('ENIAC') focused on apple products.
- Can magist handle the volumes
- Does magist have the proper market segment that we need already?
- Does magist handle the logistics to ENIACs satisfaction?

## Technologies
MySQL
Tableau

## Dataset
Magist e-commerce database (Brazilian marketplace, MySQL). Includes orders, order_items, products, sellers, customers, reviews, and payments tables —  see schema diagram below.

![database_schema](images/database_schema.png)


## Setup
1. Load `magist_dump.sql` into a local MySQL instance
2. Run queries in `Group_SQL_Analysis.sql` / `Individual_SQL_Analysis.sql`


## Repo Structure
```
├── Group_1_Magist_Proposal.pdf      # Final presentation for ENIAC
├── magist_dump.sql                  # SQL dump to load the database
├── magist_schema.pdf                # Database ER diagram
├── Group_SQL_Analysis.sql           # Structured group analysis (Q2.1–Q2.3)
├── Individual_SQL_Analysis.sql      # My independent working-through of the same questions
├── exploratory_scratch.sql          # Early scratch queries, not part of final analysis
└── README.md
```

## Key Findings
- We would advice against a cooperation
- Magist is too small for the size of ENIAC
- Magist has little experience in the premium tech segment that apple products represent
- Magist has a very little customer retention
- ENIAC would probably do better with another partner or indeed on their own, which opens the possibility of scaling dynamically

![Customer Retention](images/customer_retention.png)
![Magist vs ENIAC chart](images/Magist_vs_ENIAC.png)

## Author
Author: Niklas Livchitz — independent analysis and SQL deep dive
Group project: shared discussion and SQL work with final presentation (Group 1 Magist Proposal.pdf) were produced with bootcamp group collaborators.


