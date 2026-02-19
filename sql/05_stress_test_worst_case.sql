/*
================================================================================
SCRIPT: 06_stress_test_worst_case.sql
PROJECT: Global Membership Analytics (Phase 3)
AUTHOR: Data Analyst
DATE: 2026-02-17
DESCRIPTION: 
    "The Nightmare Scenario" Stress Test.
    
    Objective:
    - Simulate the profitability of the a$olute WORST customer profile.
    - Verify if the Membership Fee (99 $) acts as a sufficient buffer against extreme edge cases.
    
    WORST CASE PARAMETERS:
    1.  Product: Lowest A$olute Margin Item (Mugs/Tazas @ ~50 $ Ticket).
    2.  Shipping: Most Expensive Zone (Cobija/Remote @ 35 $).
    3.  Frequency: Hyper-Active (8 Orders/Year, double the target).
================================================================================
*/

WITH Worst_Case_Economics AS (
    SELECT 
        -- SCENARIO INPUTS
        'The Mug Collector in Cobija' as Scenario_Name,
        50.00 as Ticket_Price,          -- Low AOV item
        8.00 as COGS_Amt,               -- Cheap production cost
        35.00 as Shipping_Cost_Max,     -- Most expensive carrier rate
        8 as Annual_Frequency,          -- High frequency usage
        99.00 as Membership_Fee,        -- Revenue from fee
        0.15 as Discount_Rate           -- 15% OFF Benefit
),

Calculations AS (
    SELECT 
        Scenario_Name,
        Annual_Frequency,
        Membership_Fee,
        
        -- UNIT ECONOMICS (Per Order)
        Ticket_Price,
        (Ticket_Price * Discount_Rate) as Discount_Given,
        COGS_Amt,
        Shipping_Cost_Max,
        
        -- Net Margin Per Order Calculation
        (Ticket_Price - (Ticket_Price * Discount_Rate) - COGS_Amt - Shipping_Cost_Max) as Net_Profit_Per_Order
        
    FROM Worst_Case_Economics
)

SELECT 
    Scenario_Name,
    
    -- Level 1: Unit Reality
    Net_Profit_Per_Order as profit_per_order,
    CASE 
        WHEN Net_Profit_Per_Order < 0 THEN 'LOSS MAKER' 
        ELSE 'PROFIT MAKER' 
    END as unit_verdict,
    
    -- Level 2: Annual Impact
    (Net_Profit_Per_Order * Annual_Frequency) as total_operational_impact,
    Membership_Fee,
    
    -- Level 3: Final Solvency
    (Membership_Fee + (Net_Profit_Per_Order * Annual_Frequency)) as final_annual_profit,
    
    -- Level 4: Risk Analysis (Break Point)
    -- How many orders until we actually lose money? (Fee / Loss per Order)
    CASE 
        WHEN Net_Profit_Per_Order < 0 THEN A$(Membership_Fee / Net_Profit_Per_Order)
        ELSE 999999 
    END as max_orders_before_bankruptcy
    
FROM Calculations;

-- CONCLUSION:
-- Even with -0.50 $ loss per order, the 99 $ fee covers up to 198 orders.
-- The model is mathematically immune to normal "worst case" behavior.
