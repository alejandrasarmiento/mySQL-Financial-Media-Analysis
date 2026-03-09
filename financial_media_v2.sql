-- ============================================================
--  PROJECT: Financial Services — Paid Media Performance DB
--  Markets: Brazil, Mexico, USA
--  Channels: Search, Social, Affiliate, Video, Display
--  KPIs: Money Transfers, Spend, New Customers, Registrations
-- ============================================================

CREATE DATABASE IF NOT EXISTS financial_media;
USE financial_media;

-- ============================================================
-- TABLE CREATION
-- ============================================================

-- Markets / Regions
CREATE TABLE markets (
    market_id     INT PRIMARY KEY AUTO_INCREMENT,
    market_name   VARCHAR(50) NOT NULL,
    region        VARCHAR(50),
    currency      VARCHAR(10),
    country_code  VARCHAR(5)
);

-- Channels and vendors
CREATE TABLE channels (
    channel_id    INT PRIMARY KEY AUTO_INCREMENT,
    channel_name  VARCHAR(50) NOT NULL,   -- Search, Social, Affiliate, Video, Display
    vendor        VARCHAR(50),            -- Google, Meta, TikTok, Bing, YouTube, DV360
    channel_type  VARCHAR(50)
);

-- Which channels are active per market
CREATE TABLE market_channels (
    market_id   INT,
    channel_id  INT,
    is_active   BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (market_id, channel_id),
    FOREIGN KEY (market_id)  REFERENCES markets(market_id),
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

-- Campaigns
CREATE TABLE campaigns (
    campaign_id    INT PRIMARY KEY AUTO_INCREMENT,
    campaign_name  VARCHAR(150) NOT NULL,
    market_id      INT,
    channel_id     INT,
    start_date     DATE,
    end_date       DATE,
    objective      VARCHAR(50),   -- Awareness, Registrations, Transfers, New Customers
    budget         DECIMAL(12,2),
    currency       VARCHAR(10),
    status         VARCHAR(20),   -- Active, Paused, Completed
    FOREIGN KEY (market_id)  REFERENCES markets(market_id),
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

-- Daily performance — one row per campaign per day
CREATE TABLE performance (
    performance_id  INT PRIMARY KEY AUTO_INCREMENT,
    campaign_id     INT,
    report_date     DATE,
    impressions     INT,
    clicks          INT,
    spend           DECIMAL(10,2),
    registrations   INT,           -- users who completed sign-up
    new_customers   INT,           -- users who made their first transaction
    money_transfers INT,           -- total transfers completed
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Markets
INSERT INTO markets (market_name, region, currency, country_code) VALUES
('Brazil',  'LATAM',          'BRL', 'BR'),
('Mexico',  'LATAM',          'MXN', 'MX'),
('USA',     'North America',  'USD', 'US');

-- Channels
INSERT INTO channels (channel_name, vendor, channel_type) VALUES
('Search',    'Google Ads',  'Paid Search'),
('Search',    'Bing Ads',    'Paid Search'),
('Social',    'Meta',        'Paid Social'),
('Social',    'TikTok',      'Paid Social'),
('Affiliate', 'Impact',      'Affiliate'),
('Video',     'YouTube',     'Video'),
('Display',   'DV360',       'Programmatic');

-- Market + Channel availability
-- Brazil:  Search Google, Social Meta+TikTok, Affiliate, Video
-- Mexico:  Search Google+Bing, Social Meta, Affiliate, Display
-- USA:     All channels
INSERT INTO market_channels (market_id, channel_id, is_active) VALUES
(1, 1, TRUE), (1, 3, TRUE), (1, 4, TRUE), (1, 5, TRUE), (1, 6, TRUE),
(2, 1, TRUE), (2, 2, TRUE), (2, 3, TRUE), (2, 5, TRUE), (2, 7, TRUE),
(3, 1, TRUE), (3, 2, TRUE), (3, 3, TRUE), (3, 4, TRUE),
(3, 5, TRUE), (3, 6, TRUE), (3, 7, TRUE);

-- Campaigns
INSERT INTO campaigns (campaign_name, market_id, channel_id, start_date, end_date, objective, budget, currency, status) VALUES
-- BRAZIL
('BR_Google_Search_Transfers_Q1_2025',   1, 1, '2025-01-01', '2025-03-31', 'Transfers',     45000.00, 'BRL', 'Completed'),
('BR_Meta_Social_Registrations_Q1_2025', 1, 3, '2025-01-01', '2025-03-31', 'Registrations', 30000.00, 'BRL', 'Completed'),
('BR_TikTok_Awareness_Q1_2025',          1, 4, '2025-01-01', '2025-03-31', 'Awareness',     18000.00, 'BRL', 'Completed'),
('BR_Affiliate_NewCustomers_Q1_2025',    1, 5, '2025-01-01', '2025-03-31', 'New Customers', 22000.00, 'BRL', 'Completed'),
('BR_YouTube_Awareness_Q2_2025',         1, 6, '2025-04-01', '2025-06-30', 'Awareness',     15000.00, 'BRL', 'Active'),
-- MEXICO
('MX_Google_Search_Transfers_Q1_2025',   2, 1, '2025-01-01', '2025-03-31', 'Transfers',     38000.00, 'MXN', 'Completed'),
('MX_Bing_Search_Transfers_Q1_2025',     2, 2, '2025-01-01', '2025-03-31', 'Transfers',     12000.00, 'MXN', 'Completed'),
('MX_Meta_Registrations_Q2_2025',        2, 3, '2025-04-01', '2025-06-30', 'Registrations', 25000.00, 'MXN', 'Active'),
('MX_Affiliate_NewCustomers_Q1_2025',    2, 5, '2025-01-01', '2025-03-31', 'New Customers', 18000.00, 'MXN', 'Completed'),
('MX_DV360_Awareness_Q2_2025',           2, 7, '2025-04-01', '2025-06-30', 'Awareness',     20000.00, 'MXN', 'Active'),
-- USA
('US_Google_Search_Transfers_Q1_2025',   3, 1, '2025-01-01', '2025-03-31', 'Transfers',     95000.00, 'USD', 'Completed'),
('US_Bing_Search_Transfers_Q1_2025',     3, 2, '2025-01-01', '2025-03-31', 'Transfers',     30000.00, 'USD', 'Completed'),
('US_Meta_Registrations_Q1_2025',        3, 3, '2025-01-01', '2025-03-31', 'Registrations', 60000.00, 'USD', 'Completed'),
('US_TikTok_Awareness_Q2_2025',          3, 4, '2025-04-01', '2025-06-30', 'Awareness',     35000.00, 'USD', 'Active'),
('US_Affiliate_NewCustomers_Q1_2025',    3, 5, '2025-01-01', '2025-03-31', 'New Customers', 45000.00, 'USD', 'Completed'),
('US_YouTube_Awareness_Q2_2025',         3, 6, '2025-04-01', '2025-06-30', 'Awareness',     40000.00, 'USD', 'Active'),
('US_DV360_Display_Q2_2025',             3, 7, '2025-04-01', '2025-06-30', 'Awareness',     28000.00, 'USD', 'Active');

-- Daily Performance
INSERT INTO performance (campaign_id, report_date, impressions, clicks, spend, registrations, new_customers, money_transfers) VALUES
-- BRAZIL — Google Search
(1, '2025-01-15', 85000,  3200, 1800.00, 210, 145, 320),
(1, '2025-02-15', 92000,  3500, 1950.00, 240, 162, 355),
(1, '2025-03-15', 98000,  3800, 2100.00, 268, 180, 390),
-- BRAZIL — Meta Social
(2, '2025-01-15', 420000, 6500,  980.00, 380,  60,  95),
(2, '2025-02-15', 480000, 7200, 1100.00, 430,  68, 110),
(2, '2025-03-15', 455000, 6900, 1050.00, 405,  64, 102),
-- BRAZIL — TikTok
(3, '2025-01-15', 750000, 4200,  620.00, 190,  22,  48),
(3, '2025-02-15', 820000, 4800,  700.00, 215,  26,  55),
(3, '2025-03-15', 790000, 4500,  660.00, 202,  24,  51),
-- BRAZIL — Affiliate
(4, '2025-01-15',      0,    0,  720.00, 145, 110, 180),
(4, '2025-02-15',      0,    0,  810.00, 164, 124, 205),
(4, '2025-03-15',      0,    0,  770.00, 155, 117, 192),
-- BRAZIL — YouTube
(5, '2025-04-15', 980000, 2100,  520.00, 115,  18,  28),
-- MEXICO — Google Search
(6, '2025-01-15', 72000,  2800, 1500.00, 188, 130, 265),
(6, '2025-02-15', 78000,  3100, 1650.00, 208, 144, 290),
(6, '2025-03-15', 81000,  3300, 1720.00, 220, 152, 308),
-- MEXICO — Bing Search
(7, '2025-01-15', 18000,   820,  420.00,  52,  38,  68),
(7, '2025-02-15', 21000,   950,  490.00,  60,  44,  78),
(7, '2025-03-15', 19500,   880,  455.00,  56,  41,  72),
-- MEXICO — Meta
(8, '2025-04-15', 380000, 5800,  850.00, 295,  48,  88),
(8, '2025-05-15', 410000, 6200,  920.00, 320,  52,  96),
-- MEXICO — Affiliate
(9, '2025-01-15',      0,    0,  580.00, 118,  90, 145),
(9, '2025-02-15',      0,    0,  650.00, 132, 100, 163),
(9, '2025-03-15',      0,    0,  620.00, 125,  95, 155),
-- MEXICO — DV360
(10,'2025-04-15', 650000, 1800,  720.00,  88,  15,  32),
-- USA — Google Search
(11,'2025-01-15', 195000, 7200, 4200.00, 520, 360, 580),
(11,'2025-02-15', 210000, 7800, 4550.00, 562, 390, 625),
(11,'2025-03-15', 225000, 8400, 4900.00, 604, 420, 672),
-- USA — Bing Search
(12,'2025-01-15',  55000, 2100, 1200.00, 152, 105, 168),
(12,'2025-02-15',  60000, 2350, 1350.00, 170, 118, 188),
(12,'2025-03-15',  58000, 2250, 1280.00, 162, 112, 180),
-- USA — Meta
(13,'2025-01-15', 820000,12000, 2400.00, 860, 140, 220),
(13,'2025-02-15', 890000,13200, 2650.00, 948, 154, 242),
(13,'2025-03-15', 850000,12500, 2500.00, 900, 146, 230),
-- USA — TikTok
(14,'2025-04-15',1200000, 8500, 1800.00, 480,  72, 105),
(14,'2025-05-15',1350000, 9500, 2000.00, 540,  80, 118),
-- USA — Affiliate
(15,'2025-01-15',      0,    0, 1850.00, 368, 280, 462),
(15,'2025-02-15',      0,    0, 2050.00, 410, 312, 513),
(15,'2025-03-15',      0,    0, 1950.00, 390, 296, 488),
-- USA — YouTube
(16,'2025-04-15',1800000, 3800, 1650.00, 210,  32,  72),
-- USA — DV360
(17,'2025-04-15',2200000, 4200, 1400.00, 175,  28,  45);

-- ============================================================
-- QUERIES
-- ============================================================

-- -------------------------------------------------------
-- BASIC (SELECT, WHERE)
-- -------------------------------------------------------

-- Q1: All campaigns per market — objective, budget, status
SELECT
    m.market_name,
    ca.campaign_name,
    ch.channel_name,
    ch.vendor,
    ca.objective,
    ca.budget,
    ca.currency,
    ca.status
FROM campaigns ca
JOIN markets  m  ON ca.market_id  = m.market_id
JOIN channels ch ON ca.channel_id = ch.channel_id
ORDER BY m.market_name, ca.budget DESC;

-- Q2: Active campaigns only
SELECT
    m.market_name,
    ca.campaign_name,
    ch.channel_name,
    ca.objective,
    ca.budget,
    ca.currency
FROM campaigns ca
JOIN markets  m  ON ca.market_id  = m.market_id
JOIN channels ch ON ca.channel_id = ch.channel_id
WHERE ca.status = 'Active'
ORDER BY m.market_name;

-- Q3: Which channels are available per market?
SELECT
    m.market_name,
    ch.channel_name,
    ch.vendor
FROM market_channels mc
JOIN markets  m  ON mc.market_id  = m.market_id
JOIN channels ch ON mc.channel_id = ch.channel_id
WHERE mc.is_active = TRUE
ORDER BY m.market_name, ch.channel_name;

-- Q4: Campaigns focused on Registrations
SELECT
    m.market_name,
    ca.campaign_name,
    ch.channel_name,
    ca.budget,
    ca.currency,
    ca.status
FROM campaigns ca
JOIN markets  m  ON ca.market_id  = m.market_id
JOIN channels ch ON ca.channel_id = ch.channel_id
WHERE ca.objective = 'Registrations';

-- Q5: Brazil campaigns only
SELECT
    ca.campaign_name,
    ch.channel_name,
    ch.vendor,
    ca.objective,
    ca.budget,
    ca.status
FROM campaigns ca
JOIN markets  m  ON ca.market_id  = m.market_id
JOIN channels ch ON ca.channel_id = ch.channel_id
WHERE m.market_name = 'Brazil';

-- -------------------------------------------------------
-- JOINS + AGGREGATIONS
-- -------------------------------------------------------

-- Q6: Total KPIs per market
SELECT
    m.market_name,
    m.currency,
    SUM(p.spend)           AS total_spend,
    SUM(p.impressions)     AS total_impressions,
    SUM(p.clicks)          AS total_clicks,
    SUM(p.registrations)   AS total_registrations,
    SUM(p.new_customers)   AS total_new_customers,
    SUM(p.money_transfers) AS total_money_transfers
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
GROUP BY m.market_name, m.currency
ORDER BY total_money_transfers DESC;

-- Q7: Total KPIs per channel across all markets
SELECT
    ch.channel_name,
    ch.vendor,
    SUM(p.spend)           AS total_spend,
    SUM(p.registrations)   AS total_registrations,
    SUM(p.new_customers)   AS total_new_customers,
    SUM(p.money_transfers) AS total_money_transfers
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY ch.channel_name, ch.vendor
ORDER BY total_money_transfers DESC;

-- Q8: Cost per Registration per market and channel
SELECT
    m.market_name,
    ch.channel_name,
    ch.vendor,
    SUM(p.spend)         AS total_spend,
    SUM(p.registrations) AS total_registrations,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.registrations), 0), 2) AS cost_per_registration
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name, ch.vendor
ORDER BY m.market_name, cost_per_registration ASC;

-- Q9: Cost per New Customer per market and channel
SELECT
    m.market_name,
    ch.channel_name,
    ch.vendor,
    SUM(p.spend)         AS total_spend,
    SUM(p.new_customers) AS total_new_customers,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.new_customers), 0), 2) AS cost_per_new_customer
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name, ch.vendor
ORDER BY m.market_name, cost_per_new_customer ASC;

-- Q10: Cost per Money Transfer per market and channel
SELECT
    m.market_name,
    ch.channel_name,
    ch.vendor,
    SUM(p.spend)           AS total_spend,
    SUM(p.money_transfers) AS total_transfers,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.money_transfers), 0), 2) AS cost_per_transfer
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name, ch.vendor
ORDER BY m.market_name, cost_per_transfer ASC;

-- Q11: Registration to New Customer conversion rate
-- (how many registrations turn into actual customers?)
SELECT
    m.market_name,
    ch.channel_name,
    SUM(p.registrations)  AS total_registrations,
    SUM(p.new_customers)  AS total_new_customers,
    ROUND(SUM(p.new_customers) * 100.0 / NULLIF(SUM(p.registrations), 0), 2) AS reg_to_customer_rate
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name
ORDER BY reg_to_customer_rate DESC;

-- Q12: Brazil vs Mexico vs USA — full KPI comparison side by side
SELECT
    m.market_name,
    ch.channel_name,
    SUM(p.spend)           AS total_spend,
    SUM(p.registrations)   AS registrations,
    SUM(p.new_customers)   AS new_customers,
    SUM(p.money_transfers) AS money_transfers,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.registrations),   0), 2) AS cost_per_reg,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.new_customers),   0), 2) AS cost_per_customer,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.money_transfers), 0), 2) AS cost_per_transfer
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name
ORDER BY ch.channel_name, m.market_name;

-- Q13: Affiliate performance — no impressions/clicks, pure conversion focus
SELECT
    m.market_name,
    SUM(p.spend)           AS total_spend,
    SUM(p.registrations)   AS registrations,
    SUM(p.new_customers)   AS new_customers,
    SUM(p.money_transfers) AS money_transfers,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.new_customers),   0), 2) AS cost_per_customer,
    ROUND(SUM(p.spend) / NULLIF(SUM(p.money_transfers), 0), 2) AS cost_per_transfer
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
WHERE ch.channel_name = 'Affiliate'
GROUP BY m.market_name
ORDER BY cost_per_transfer ASC;

-- Q14: Full dashboard — all KPIs per market, channel and campaign
SELECT
    m.market_name,
    ch.channel_name,
    ch.vendor,
    ca.campaign_name,
    ca.objective,
    ca.status,
    SUM(p.impressions)     AS impressions,
    SUM(p.clicks)          AS clicks,
    SUM(p.spend)           AS spend,
    SUM(p.registrations)   AS registrations,
    SUM(p.new_customers)   AS new_customers,
    SUM(p.money_transfers) AS money_transfers,
    ROUND(SUM(p.clicks)*100.0   / NULLIF(SUM(p.impressions),   0), 4) AS ctr_pct,
    ROUND(SUM(p.spend)          / NULLIF(SUM(p.registrations),  0), 2) AS cost_per_reg,
    ROUND(SUM(p.spend)          / NULLIF(SUM(p.new_customers),  0), 2) AS cost_per_customer,
    ROUND(SUM(p.spend)          / NULLIF(SUM(p.money_transfers),0), 2) AS cost_per_transfer
FROM performance p
JOIN campaigns ca ON p.campaign_id = ca.campaign_id
JOIN markets   m  ON ca.market_id  = m.market_id
JOIN channels  ch ON ca.channel_id = ch.channel_id
GROUP BY m.market_name, ch.channel_name, ch.vendor,
         ca.campaign_name, ca.objective, ca.status
ORDER BY m.market_name, spend DESC;
