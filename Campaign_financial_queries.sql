-- ================================================
-- FINANCIAL MEDIA - CAMPAIGN QUERYS DATA
-- Alejandra Sarmiento | Q1 2025
-- ================================================

-- Q1:What channels ran in Q1?
SELECT DISTINCT channel
FROM raw_data
ORDER BY channel;

-- Q2: What regions are in the data?
SELECT DISTINCT region
FROM raw_data
ORDER BY region;

-- Q3: What datasources (platforms) were used?
SELECT DISTINCT datasource_name
FROM raw_data
ORDER BY datasource_name;

-- Q4: Which campaigns had zero spend?
SELECT DISTINCT campaign_name, channel, datasource_name
FROM raw_data
WHERE spend = 0
ORDER BY channel;

-- Q5: What does LACA region data look like?
SELECT DISTINCT channel, datasource_name, client_name
FROM raw_data
WHERE region = 'LACA'
ORDER BY channel;

-- Q6: Total spend, impressions and clicks by channel
SELECT 
    channel,
    ROUND(SUM(spend), 0) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks
FROM raw_data
GROUP BY channel
ORDER BY total_spend DESC;

-- Q7: Total KPIs by region
SELECT 
    region,
    ROUND(SUM(spend), 0) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(money_transfers) AS total_mtransfers,
    SUM(registrations) AS total_registrations,
    SUM(new_customers) AS total_new_customers
FROM raw_data
GROUP BY region
ORDER BY total_spend DESC;

-- Q8: Which channel drove the most money transfers?
SELECT 
    channel,
    SUM(money_transfers) AS total_transfers,
    ROUND(SUM(spend), 0) AS total_spend,
    ROUND(SUM(spend) / NULLIF(SUM(money_transfers), 0), 2) AS cost_per_transfer
FROM raw_data
GROUP BY channel
ORDER BY total_transfers DESC;

-- Q9: Which channel drove the most registrations?
SELECT 
    channel,
    SUM(registrations) AS total_registrations,
    ROUND(SUM(spend), 0) AS total_spend,
    ROUND(SUM(spend) / NULLIF(SUM(registrations), 0), 2) AS cost_per_registration
FROM raw_data
GROUP BY channel
ORDER BY total_registrations ASC;

-- Q10: Which channel had the best CTR (Click-Through Rate)?
SELECT 
    channel,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0) * 100, 2) AS ctr_percentage
FROM raw_data
GROUP BY channel
ORDER BY ctr_percentage DESC;

-- Q11: Cost per Money Transfer by channel
SELECT 
    channel,
    SUM(money_transfers) AS total_transfers,
    ROUND(SUM(spend), 0) AS total_spend,
    ROUND(SUM(spend) / NULLIF(SUM(money_transfers), 0), 2) AS cost_per_transfer
FROM raw_data
GROUP BY channel
ORDER BY cost_per_transfer ASC;

-- Q12: Full dashboard: all KPIs and costs per channel
SELECT 
    channel,
    ROUND(SUM(spend), 0) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(money_transfers) AS total_transfers,
    SUM(registrations) AS total_registrations,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(clicks) / NULLIF(SUM(impressions), 0) * 100, 2) AS ctr,
    ROUND(SUM(spend) / NULLIF(SUM(money_transfers), 0), 2) AS cost_per_transfer,
    ROUND(SUM(spend) / NULLIF(SUM(registrations), 0), 2) AS cost_per_registration,
    ROUND(SUM(spend) / NULLIF(SUM(new_customers), 0), 2) AS cost_per_new_customer
FROM raw_data
GROUP BY channel
ORDER BY total_spend DESC;
