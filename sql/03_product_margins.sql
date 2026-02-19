/*
================================================================================
SCRIPT: 04_product_margins.sql
PROJECT: Global Membership Analytics (Phase 3)
AUTHOR: Data Analyst
DATE: 2026-02-17
DESCRIPTION: 
    Product Mix & Margin Analysis (The "Unit Economics").
    
    Objective:
    - Determine which product categories dominate revenue (Top Contribution).
    - Calculate Weighted Gross Margin (COGS) to prove profitability of each order.
    
    Business Rules (COGS):
    - T-Shirts/Poleras (63% vol): ~55% Margin (Sell 100, Cost 45)
    - Hoodies/Sudaderas (11% vol): ~48% Margin (Sell 220, Cost 115)
    - Caps/Gorras (4% vol): ~81% Margin (Sell 100, Cost 19)
================================================================================
*/

-- 1. CLASSIFY & AGGREGATE (The "Mix")
WITH Categorized_Items AS (
    SELECT 
        oi.order_item_name,
        oi.line_total,
        oi.qty,
        -- LOGIC: Map raw item names to Standard Categories
        CASE 
            WHEN LOWER(oi.order_item_name) LIKE '%polera%' OR LOWER(oi.order_item_name) LIKE '%shirt%' THEN 'Apparel (High Margin)'
            WHEN LOWER(oi.order_item_name) LIKE '%sudadera%' OR LOWER(oi.order_item_name) LIKE '%hoodie%' THEN 'Apparel (Med Margin)'
            WHEN LOWER(oi.order_item_name) LIKE '%gorra%' OR LOWER(oi.order_item_name) LIKE '%cap%' THEN 'Accessories (Very High Margin)'
            ELSE 'Other (Standard Margin)'
        END as product_category,
        
        -- LOGIC: Apply Margin Rules (Validated Assumption)
        CASE 
            WHEN LOWER(oi.order_item_name) LIKE '%polera%' OR LOWER(oi.order_item_name) LIKE '%shirt%' THEN 0.55
            WHEN LOWER(oi.order_item_name) LIKE '%sudadera%' OR LOWER(oi.order_item_name) LIKE '%hoodie%' THEN 0.48
            WHEN LOWER(oi.order_item_name) LIKE '%gorra%' OR LOWER(oi.order_item_name) LIKE '%cap%' THEN 0.81
            ELSE 0.50 -- Default conservative margin
        END as estimated_margin_pct
        
    FROM stg_order_items oi
    WHERE oi.line_total > 0 -- Exclude freebies/shipping lines
)

-- 2. WEIGHTED PROFITABILITY (The "Golden Number")
SELECT 
    product_category,
    SUM(qty) as units_sold,
    SUM(line_total) as total_revenue,
    AVG(line_total/qty) as avg_price_unit,
    AVG(estimated_margin_pct) as avg_margin_pct,
    
    -- Contribution to Total Gross Profit
    SUM(line_total * estimated_margin_pct) as total_gross_profit_contribution,
    
    -- % of Total Business (Pareto Check)
    (SUM(line_total) * 100.0 / SUM(SUM(line_total)) OVER()) as pct_revenue_share
    
FROM Categorized_Items
GROUP BY product_category
ORDER BY total_revenue DESC;

-- CONCLUSION FOR PORTFOLIO:
-- With T-Shirts dominating (60%+ Revenue) at 55% Margin, 
-- a Global Blender Margin of 50% is a safe, conservative baseline for modeling.
