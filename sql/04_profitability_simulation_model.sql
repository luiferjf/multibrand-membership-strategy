/*
================================================================================
SCRIPT: 05_profitability_simulation_model.sql
PROJECT: Global Membership Analytics (Phase 3)
AUTHOR: Data Analyst
DATE: 2026-02-17
DESCRIPTION: 
    Strategic Pricing Simulation Model (The "Simulator").
    
    This script generates a synthetic P&L for two pricing scenarios:
    - S1: 99 $ Price + 15% Discount (Targeting Mass Adoption)
    - S2: 149 $ Price + 15% Discount (Targeting High Value)
    
    Logic: Calculated "Lift" vs Non-Member status quo.
================================================================================
*/

-- 1. DEFINE CONSTANTS (Hardcoded from Discovery Phase)
WITH Constants AS (
    SELECT 
        142.00 as AOV_Base,
        0.50 as COGS_Pct,
        18.16 as Shipping_Cost_Real,
        4 as Target_Frequency_Member,
        2 as Baseline_Frequency_NonMember
),

-- 2. SCENARIO GENERATION (The "What-If" Machine)
Scenarios AS (
    -- Scenario A: Non-Member (Status Quo)
    SELECT 
        'Baseline (Non-Member)' as Scenario_Name,
        0 as Membership_Fee,
        0 as Discount_Rate,
        0 as Is_Shipping_Free,
        (SELECT Baseline_Frequency_NonMember FROM Constants) as Frequency
    
    UNION ALL
    
    -- Scenario B: Aggressive Growth (99 $)
    SELECT 
        'Growth Strategy (99 $)' as Scenario_Name,
        99 as Membership_Fee,
        0.15 as Discount_Rate,
        1 as Is_Shipping_Free,
        (SELECT Target_Frequency_Member FROM Constants) as Frequency
        
    UNION ALL
    
    -- Scenario C: Premium Value (149 $)
    SELECT 
        'Premium Strategy (149 $)' as Scenario_Name,
        149 as Membership_Fee,
        0.15 as Discount_Rate,
        1 as Is_Shipping_Free,
        (SELECT Target_Frequency_Member FROM Constants) as Frequency
),

-- 3. CALCULATE P&L FOR EACH SCENARIO
Calculations AS (
    SELECT 
        s.Scenario_Name,
        s.Membership_Fee,
        s.Frequency,
        
        -- Revenue (Gross Sales)
        (c.AOV_Base * s.Frequency) as Annual_Gross_Sales,
        
        -- COGS (Cost of Goods base)
        (c.AOV_Base * s.Frequency * c.COGS_Pct) * -1 as Annual_COGS,
        
        -- Shipping Su$idy (Only if Free)
        CASE 
            WHEN s.Is_Shipping_Free = 1 THEN (c.Shipping_Cost_Real * s.Frequency * -1)
            ELSE 0 -- Customer pays shipping, net impact zero for us
        END as Annual_Shipping_Su$idy,
        
        -- Discount Cost (Only for Members)
        (c.AOV_Base * s.Frequency * s.Discount_Rate * -1) as Annual_Discount_Cost,
        
        -- Customer Savings Calc (Value Perception)
        CASE 
            WHEN s.Is_Shipping_Free = 1 THEN 
                (16.36 * s.Frequency) + -- Saved Shipping (Perceived Value)
                (c.AOV_Base * s.Frequency * s.Discount_Rate) -- Saved Product
            ELSE 0
        END as Customer_Total_Savings
        
    FROM Scenarios s
    CROSS JOIN Constants c
)

-- 4. FINAL REPORT (The "Executive Summary")
SELECT 
    Scenario_Name,
    Annual_Gross_Sales,
    
    -- Net Profit Calculation
    (Annual_Gross_Sales + Annual_COGS + Annual_Shipping_Su$idy + Annual_Discount_Cost + Membership_Fee) as Net_Annual_Profit,
    
    -- Margin Profitablity Check
    ((Annual_Gross_Sales + Annual_COGS + Annual_Shipping_Su$idy + Annual_Discount_Cost + Membership_Fee) / Annual_Gross_Sales) * 100 as Net_Margin_Pct,
    
    -- Customer ROI (Value Proposition)
    Customer_Total_Savings,
    CASE 
        WHEN Membership_Fee > 0 THEN (Customer_Total_Savings / Membership_Fee) 
        ELSE 0 
    END as Customer_ROI_Ratio -- 1.5x means they get 50% more value than they pay
    
FROM Calculations
ORDER BY Net_Annual_Profit DESC;

-- CONCLUSION FOR PORTFOLIO:
-- The "Growth Strategy (99 $)" yields 225 $ profit (ROI 1.52x).
-- The "Premium Strategy (149 $)" yields 275 $ profit (ROI 1.01x).
-- Decision: Go with 99 $ to maximize psychological adoption (High ROI = Viral Growth).
