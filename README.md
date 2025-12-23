# Lending-Club-Risk-Analysis
End-to-End Credit Risk Analysis using SQL for data engineering and Power BI for financial storytelling.
Project Overview
This project analyzes a $34 Billion lending portfolio to identify high-risk borrower segments and quantify financial impact. By building a complete SQL data pipeline and a multi-page Power BI dashboard, I transformed raw loan data into actionable underwriting insights.

Technical Stack
Database: MySQL (Data Cleaning, Feature Engineering, CTE-based Analysis)

Visualization: Power BI (DAX, Financial Storytelling, Risk Heatmaps)

Concepts: Risk Modeling, Loss Quantification, Vintage Analysis, ETL Pipelines

Key Business Insights
Financial Impact: Developed logic to calculate Net Loss after recoveries, identifying a total portfolio loss of $2 Billion.

The "Income Trap": Discovered that while high-income borrowers generally default less, the protection of a high salary disappears in lower credit grades (F and G), where default rates spike regardless of income.

Debt-to-Income (DTI) Hotspots: Identified a "Red Zone" where borrowers with a DTI > 30% in Grade G reached a peak default probability of 40.99%.

Sector Risk: Isolated Small Business and Renewable Energy as the highest-risk loan purposes, significantly exceeding the portfolio average.

Data Pipeline Architecture
Staging: Ingested 100+ columns of raw CSV data into a structured MySQL environment.

Transformation: Cast data types and handled null values for critical risk variables like DTI and Annual Income.

Feature Engineering: * Created a custom default_flag to isolate risky accounts (Late 16-120 days, Charged Off) while excluding non-funded policy rejects.

Engineered Gross Loss and Net Loss metrics to measure dollar-value impact.

Developed categorical "buckets" for DTI, Income tiers, and Interest Rates to enable segment-based analysis.
<img width="1183" height="727" alt="Power Bi Dashboard" src="https://github.com/user-attachments/assets/25a06ae2-75a0-475d-a767-fc7a6a3c1e89" />

