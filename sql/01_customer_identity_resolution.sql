-- =========================================================================================================
-- SCRIPT: 02_customer_identity_resolution.sql
-- AUTHOR: Antigravity
-- DATE: 2026-02-17
-- DESCRIPTION: Creates a unified view of customers across all 4 Agent Lab stores (PAS, RBN, VIC, NEB).
--              Uses a prioritized matching logic (Email > Phone) to merge identities.
--              Falls back to 'Unidentified Walk-in' if no contact info exists.
-- =========================================================================================================

-- 1. Create a Staging View that standardizes customer keys from all stores
CREATE OR REPLACE VIEW stg_unified_customer_base AS
SELECT
    oi.store_code,
    oi.customer_user_id AS local_customer_id,
    LOWER(TRIM(oi.email_hash)) AS email_hash, -- Using hash for privacy, treating as unique ID
    oi.phone_hash,
    CASE 
        WHEN oi.email_hash IS NOT NULL AND oi.email_hash != '' THEN 'Email'
        WHEN oi.phone_hash IS NOT NULL AND oi.phone_hash != '' THEN 'Phone'
        ELSE 'Unknown'
    END AS identity_type
FROM stg_order_identity oi
-- We only want distinct customers, not every order
GROUP BY 1, 2, 3, 4;

-- 2. Create the Master Customer Map (The "Golden Record")
-- This table assigns a NEW global_customer_id to each unique person
CREATE TABLE IF NOT EXISTS dim_global_customer_map (
    global_customer_id VARCHAR(64) PRIMARY KEY,
    primary_identity_key VARCHAR(255), -- The email or phone used to match
    identity_source VARCHAR(20),       -- 'Email' or 'Phone'
    first_seen_store VARCHAR(10),
    first_seen_date DATETIME
);

-- Note: Since we are in a read-only environment for the main DB, 
-- we will simulate the creation of this mapping logic via a query 
-- that can be run to generate the analysis dataset.

-- 3. The Analysis Query: "Who buys where?"
-- This query returns the dataset needed for the Membership Simulation
-- showing total spend and cross-store behavior per unique human.

SELECT
    COALESCE(u.email_hash, u.phone_hash, CONCAT('UNKNOWN-', u.store_code, '-', u.local_customer_id)) AS global_id,
    
    -- Aggregated Metrics
    COUNT(DISTINCT u.store_code) AS unique_stores_visited,
    GROUP_CONCAT(DISTINCT u.store_code ORDER BY u.store_code) AS visited_stores,
    
    -- Lifetime Value (approximate aggregation)
    SUM(o.net_revenue) AS total_lifetime_spend,
    COUNT(DISTINCT o.order_id) AS total_lifetime_orders,
    
    -- Membership Potential Indicators
    SUM(o.shipping_total) AS total_shipping_paid,
    AVG(o.shipping_total) AS avg_shipping_per_order,
    
    -- Recency
    MAX(o.order_created_utc) AS last_purchase_date

FROM stg_unified_customer_base u
JOIN stg_orders o 
    ON u.store_code = o.store_code 
    AND u.local_customer_id = o.customer_id
WHERE o.status_canonical NOT IN ('Cancelled', 'Refunded', 'Failed')
GROUP BY 1
HAVING total_lifetime_orders > 0
ORDER BY total_lifetime_spend DESC;
