/*
===============================================================================
LENDING CLUB: END-TO-END CREDIT RISK & FINANCIAL LOSS ANALYSIS
===============================================================================
Author: Ibrahim Shaik
Role: Data Analyst
Location: Hyderabad / Bangalore
Logic: Full SQL Pipeline from Raw Data to Business Intelligence CTEs
===============================================================================
*/

-- ----------------------------------------------------------------------------
-- 1. DATABASE & STAGING SETUP
-- ----------------------------------------------------------------------------
CREATE TABLE lending_table (
id varchar(100),	
member_id varchar(100),
loan_amnt varchar(100),
funded_amnt varchar(100),
funded_amnt_inv varchar(100),	
term varchar(100),	
int_rate varchar(100),
installment varchar(100),
grade varchar(10),	
sub_grade varchar(10),	
emp_title varchar(100),
emp_length varchar(100),
home_ownership varchar(100),
annual_inc varchar(100),
verification_status varchar(50),	
issue_d varchar(50),
loan_status varchar(50),
pymnt_plan varchar(50),
url varchar(50),
descr varchar(500),
purpose varchar(50),
title varchar(50),
zip_code varchar(50),
addr_state varchar(10),
dti varchar(100),
delinq_2yrs varchar(100),
earliest_cr_line varchar(50),	
inq_last_6mths varchar(100),
mths_since_last_delinq varchar(100),
mths_since_last_record varchar(100),
open_acc varchar(100),
pub_rec varchar(100),
revol_bal varchar(100),
revol_util varchar(100),
total_acc varchar(100),
initial_list_status varchar(10),
out_prncp varchar(100),
out_prncp_inv varchar(100),
total_pymnt varchar(100),
total_pymnt_inv varchar(100),
total_rec_prncp varchar(100),
total_rec_int varchar(100),
total_rec_late_fee varchar(100),
recoveries varchar(100),
collection_recovery_fee varchar(100),
last_pymnt_d varchar(50),
last_pymnt_amnt varchar(100),
next_pymnt_d varchar(50),
last_credit_pull_d varchar(50),
collections_12_mths_ex_med varchar(100),
mths_since_last_major_derog varchar(100),
policy_code varchar(100),
application_type varchar(50),	
annual_inc_joint varchar(100),
dti_joint varchar(100),
verification_status_joint varchar(50),	
acc_now_delinq varchar(100),
tot_coll_amt varchar(100),
tot_cur_bal varchar(100),
open_acc_6m varchar(100),
open_act_il varchar(100),
open_il_12m varchar(100),
open_il_24m varchar(100),
mths_since_rcnt_il varchar(100),	
total_bal_il varchar(100),
il_util varchar(100),
open_rv_12m varchar(100),
open_rv_24m varchar(100),
max_bal_bc varchar(100),
all_util varchar(100),
total_rev_hi_lim varchar(100),	
inq_fi varchar(100),
total_cu_tl varchar(100),
inq_last_12m varchar(100),
acc_open_past_24mths varchar(100),	
avg_cur_bal varchar(100),
bc_open_to_buy varchar(100),
bc_util varchar(100),
chargeoff_within_12_mths varchar(100),
delinq_amnt varchar(100),
mo_sin_old_il_acct varchar(100),
mo_sin_old_rev_tl_op varchar(100),
mo_sin_rcnt_rev_tl_op varchar(100),
mo_sin_rcnt_tl varchar(100),
mort_acc varchar(100),
mths_since_recent_bc varchar(100),
mths_since_recent_bc_dlq varchar(100),
mths_since_recent_inq varchar(100),
mths_since_recent_revol_delinq varchar(100),
num_accts_ever_120_pd varchar(100),
num_actv_bc_tl varchar(100),
num_actv_rev_tl varchar(100),
num_bc_sats varchar(100),
num_bc_tl varchar(100),
num_il_tl varchar(100),
num_op_rev_tl varchar(100),
num_rev_accts varchar(100),
num_rev_tl_bal_gt_0 varchar(100),	
num_sats varchar(100),
num_tl_120dpd_2m varchar(100),	
num_tl_30dpd varchar(100),
num_tl_90g_dpd_24m varchar(100),
num_tl_op_past_12m varchar(100),
pct_tl_nvr_dlq varchar(100),
percent_bc_gt_75 varchar(100),
pub_rec_bankruptcies varchar(100),
tax_liens varchar(100),
tot_hi_cred_lim varchar(100),
total_bal_ex_mort varchar(100),
total_bc_limit varchar(100),
total_il_high_credit_limit varchar(100),	
revol_bal_joint varchar(100),
sec_app_earliest_cr_line varchar(100),	
sec_app_inq_last_6mths varchar(100),
sec_app_mort_acc varchar(100),
sec_app_open_acc varchar(100),
sec_app_revol_util varchar(100),
sec_app_open_act_il varchar(100),
sec_app_num_rev_accts varchar(100),
sec_app_chargeoff_within_12_mths varchar(100),	
sec_app_collections_12_mths_ex_med varchar(100),
sec_app_mths_since_last_major_derog varchar(100),
hardship_flag varchar(10),
hardship_type varchar(250),
hardship_reason varchar(250),
hardship_status varchar(100),
deferral_term varchar(100),
hardship_amount varchar(100),
hardship_start_date varchar(50),
hardship_end_date varchar(50),
payment_plan_start_date varchar(50),
hardship_length varchar(100),
hardship_dpd varchar(100),
hardship_loan_status varchar(50),	
orig_projected_additional_accrued_interest varchar(100),	
hardship_payoff_balance_amount varchar(100),
hardship_last_payment_amount varchar(100),
disbursement_method varchar(50),
debt_settlement_flag varchar(10),
debt_settlement_flag_date varchar(50),
settlement_status varchar(50),
settlement_date varchar(50),
settlement_amount varchar(100),
settlement_percentage varchar(100),
settlement_term varchar(50)
);

-- Load data from local path 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/lending_data.csv' 
INTO TABLE lending_table 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;





-- ----------------------------------------------------------------------------
-- 2. TRANSFORMATION LAYER 
-- ----------------------------------------------------------------------------
-- Create staging table to handle raw CSV ingestion
create table lending_clean as
select
    id,
    issue_d,
    loan_status,
    grade,
    term,
    purpose,
    addr_state,

    cast(loan_amnt as decimal(10,2))     as loan_amnt,
    cast(funded_amnt as decimal(10,2))   as funded_amnt,
    cast(total_pymnt as decimal(10,2))   as total_pymnt,
    cast(recoveries as decimal(10,2))    as recoveries,

    case
        when dti in ('', '999') then null
        else cast(dti as decimal(10,2))
    end as dti,

    case
        when annual_inc in ('', '0') then null
        else cast(annual_inc as decimal(12,2))
    end as annual_inc,

    cast(int_rate as decimal(5,2)) as int_rate

from lending_table;
-- ----------------------------------------------------------------------------
-- 3. FEATURE ENGINEERING & FINANCIAL CALCULATIONS
-- ----------------------------------------------------------------------------

-- Add columns for risk indicators and performance buckets
ALTER TABLE lending_clean 
ADD COLUMN default_flag TINYINT,
ADD COLUMN gross_loss DECIMAL(10,2),
ADD COLUMN net_loss DECIMAL(10,2),
ADD COLUMN dti_bucket VARCHAR(20),
ADD COLUMN income_bucket VARCHAR(20),
ADD COLUMN rate_bucket VARCHAR(20);

-- A. Risk Flagging Logic (Excluding Policy Non-Met loans per screenshot logic)
UPDATE lending_clean SET default_flag = 0 WHERE loan_status IN ('Fully Paid', 'Current');

UPDATE lending_clean 
SET default_flag = 1 
WHERE loan_status IN (
    'Charged Off', 
    'Default', 
    'Late (31-120 days)', 
    'Late (16-30 days)'
);

-- B. Loss Metric Calculations
UPDATE lending_clean 
SET gross_loss = funded_amnt - total_pymnt,
    net_loss = funded_amnt - (total_pymnt + recoveries)
WHERE default_flag = 1;

-- C. Behavioral Segmentation Buckets
UPDATE lending_clean SET dti_bucket = 
    CASE WHEN dti < 15 THEN 'low' WHEN dti >= 15 AND dti < 30 THEN 'medium' ELSE 'high' END;

UPDATE lending_clean SET income_bucket = 
    CASE WHEN annual_inc < 50000 THEN 'low' WHEN annual_inc < 100000 THEN 'medium' ELSE 'high' END;

UPDATE lending_clean SET rate_bucket = 
    CASE WHEN int_rate < 10 THEN 'low' WHEN int_rate < 25 THEN 'medium' ELSE 'high' END;

-- ----------------------------------------------------------------------------
-- 4. BUSINESS ANALYSIS & KPI EXTRACTION (Power BI Support)
-- ----------------------------------------------------------------------------

-- A. Summary Loss KPI Card Validation
SELECT 
    default_flag,
    COUNT(*) AS loan_count,
    SUM(funded_amnt) AS total_funded,
    SUM(net_loss) AS total_net_loss
FROM lending_clean
GROUP BY default_flag;

-- B. Risk Hotspot Heatmap (Grade vs DTI)
WITH total_table AS (SELECT grade, dti_bucket, COUNT(*) as total_count FROM lending_clean GROUP BY grade, dti_bucket),
     default_table AS (SELECT grade, dti_bucket, COUNT(*) as default_count FROM lending_clean WHERE default_flag = 1 GROUP BY grade, dti_bucket)
SELECT t.grade, t.dti_bucket, (COALESCE(default_count,0) / CAST(total_count AS DECIMAL(12,2))) * 100 AS default_rate
FROM total_table t LEFT JOIN default_table d ON t.grade = d.grade AND t.dti_bucket = d.dti_bucket
ORDER BY grade;

-- C. The "Income Trap" Analysis (Grade vs Income)
WITH total_table AS (SELECT grade, income_bucket, COUNT(*) as total_count FROM lending_clean GROUP BY grade, income_bucket),
     default_table AS (SELECT grade, income_bucket, COUNT(*) as default_count FROM lending_clean WHERE default_flag = 1 GROUP BY grade, income_bucket)
SELECT t.grade, t.income_bucket, (COALESCE(default_count,0) / CAST(total_count AS DECIMAL(12,2))) * 100 AS default_rate
FROM total_table t LEFT JOIN default_table d ON t.grade = d.grade AND t.income_bucket = d.income_bucket
ORDER BY grade, FIELD(t.income_bucket, 'low', 'medium', 'high');

-- D. Interest Rate Premium vs Risk (Grade vs Rate Bucket)
WITH total_table AS (SELECT grade, rate_bucket, COUNT(*) as total_count FROM lending_clean GROUP BY grade, rate_bucket),
     default_table AS (SELECT grade, rate_bucket, COUNT(*) as default_count FROM lending_clean WHERE default_flag = 1 GROUP BY grade, rate_bucket)
SELECT t.grade, t.rate_bucket, (COALESCE(default_count,0) / CAST(total_count AS DECIMAL(12,2))) * 100 AS default_rate
FROM total_table t LEFT JOIN default_table d ON t.grade = d.grade AND t.rate_bucket = d.rate_bucket
ORDER BY grade, default_rate;

-- E. Loan Quality by Purpose
WITH total_table AS (SELECT purpose, COUNT(*) as total_count FROM lending_clean GROUP BY purpose),
     default_table AS (SELECT purpose, COUNT(*) as default_count FROM lending_clean WHERE default_flag = 1 GROUP BY purpose)
SELECT t.purpose, (COALESCE(default_count,0) / CAST(total_count AS DECIMAL(12,2))) * 100 AS default_rate
FROM total_table t LEFT JOIN default_table d ON t.purpose = d.purpose
ORDER BY default_rate DESC;

-- F. Credit Quality Over Time (Vintage Analysis / Yearly Trend)
WITH yearly_total AS (
    SELECT grade, YEAR(STR_TO_DATE(CONCAT('01-', issue_d), '%d-%b-%Y')) AS issue_year, COUNT(*) as total_count 
    FROM lending_clean GROUP BY grade, issue_year
),
yearly_default AS (
    SELECT grade, YEAR(STR_TO_DATE(CONCAT('01-', issue_d), '%d-%b-%Y')) AS issue_year, COUNT(*) as default_count 
    FROM lending_clean WHERE default_flag = 1 GROUP BY grade, issue_year
)
SELECT y.grade, y.issue_year, (COALESCE(default_count,0) / CAST(total_count AS DECIMAL(12,2))) * 100 AS default_rate
FROM yearly_total y LEFT JOIN yearly_default d ON y.grade = d.grade AND y.issue_year = d.issue_year
ORDER BY grade, issue_year;