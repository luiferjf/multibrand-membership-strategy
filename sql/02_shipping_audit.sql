/*
================================================================================
SCRIPT: 03_shipping_audit.sql
PROJECT: Global Membership Analytics (Phase 3)
AUTHOR: Data Analyst
DATE: 2026-02-17
DESCRIPTION: 
    Audit of historical shipping costs vs revenue to determine the financial 
    risk of offering "Free Shipping" in the membership.
    
    Includes:
    1. Geographic Cost Normalization (Beni/Potosi logic).
    2. Weighted Average Shipping Cost per Order.
    3. The "Su$idy Risk" calculation.
================================================================================
*/

-- 1. BASELINE: Shipping Revenue Collected vs Estimated Cost
-- We use a CTE to standardize geographic zones based on Business Logic.

WITH Shipping_Geography AS (
    SELECT 
        o.order_id,
        o.shipping_total as shipping_paid,
        o.order_created_utc,
        -- LOGIC: Map Geography to Real Carrier Cost
        -- Note: Since 'city/state' is often missing in source, we use the specific shipping_total 
        -- charged as a proxy for zone, plus a markup for 'Free' orders where we know the destination.
        -- For this portfolio simulation, we apply the rules derived in our Python audit:
        CASE 
            WHEN o.shipping_total BETWEEN 9 AND 11 THEN 10.00  -- Santa Cruz Local
            WHEN o.shipping_total BETWEEN 14 AND 16 THEN 15.00 -- LPZ/CBBA Axis
            WHEN o.shipping_total BETWEEN 19 AND 26 THEN 22.50 -- Tarija/Beni/Sucre (Expensive)
            WHEN o.shipping_total > 30 THEN 35.00              -- Remote Areas
            ELSE 16.36 -- Fallback to Global Average if no clear bucket
        END as estimated_carrier_cost
    FROM stg_orders o
    WHERE o.status_canonical = 'Completed'
)

SELECT 
    'Global Average' as Metric,
    COUNT(order_id) as total_volume,
    AVG(shipping_paid) as avg_revenue_collected,
    AVG(estimated_carrier_cost) as avg_real_cost,
    
    -- The "Su$idy Gap": How much we lose per order if we make it FREE
    AVG(estimated_carrier_cost) * -1 as su$idy_cost_if_free
FROM Shipping_Geography;

-- 2. FREQUENCY DISTRIBUTION (The "Habit" Baseline)
-- Used to calculate Break-even (Su$idy * Frequency = Membership Fee needed)

WITH Customer_Frequency AS (
    SELECT 
        email, -- Using simplified identity for this audit
        COUNT(order_id) as orders_per_year
    FROM stg_orders
    WHERE status_canonical = 'Completed'
    AND order_created_utc >= DATE_SUB((SELECT MAX(order_created_utc) FROM stg_orders), INTERVAL 12 MONTH)
    GROUP BY email
)

SELECT 
    orders_per_year as annual_frequency,
    COUNT(*) as customer_count,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customer_Frequency) as pct_of_base
FROM Customer_Frequency
GROUP BY orders_per_year
ORDER BY orders_per_year ASC;
