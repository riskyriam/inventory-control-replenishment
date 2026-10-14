-- Daily Coverage adalah cara memperkirakan berapa hari stok yang tersedia bisa memenuhi permintaan berdasakan rata-rata demand harian
WITH daily_coverage AS (
	SELECT
		Date,
		Store_ID,
		Product_ID,
		Inventory_Level,
		Demand,
		ROUND(CAST(Inventory_Level AS FLOAT) / NULLIF(CAST(Demand as FLOAT),0),2) AS days_supply 
	FROM dbo.sales_data
),
average_demand AS (
    SELECT
        Store_ID,
        Product_ID,
        ROUND(AVG(CAST(Demand AS FLOAT)),2) AS Average_Daily_Demand
    FROM sales_data
    GROUP BY
        Store_ID,
        Product_ID
),
coverage_target AS (
    SELECT
        *,
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY Days_Supply)
            OVER (
                PARTITION BY Store_ID, Product_ID
            ) AS Reorder_DOS_Threshold,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY Days_Supply)
            OVER (
                PARTITION BY Store_ID, Product_ID
            ) AS Target_Days_of_Supply,

        ROW_NUMBER() OVER (
            PARTITION BY Store_ID, Product_ID
            ORDER BY [Date] DESC
        ) AS rn

    FROM daily_coverage
)


SELECT
    c.Store_ID,
    c.Product_ID,
    c.[Date] AS Latest_Date,
    c.Inventory_Level,
    c.Demand,
    c.Days_Supply,
    c.Target_Days_of_Supply,
    a.Average_Daily_Demand,

    a.Average_Daily_Demand
        * c.Target_Days_of_Supply AS Target_Inventory,
        
    CASE
        WHEN c.Days_Supply IS NULL
            THEN 'Check Demand'
        WHEN c.Days_Supply <= c.Reorder_DOS_Threshold
            THEN 'Reorder'
        ELSE 'No Reorder'
    END AS When_to_Reorder,

    CASE
        WHEN c.Days_Supply <= c.Reorder_DOS_Threshold
             AND (
                 a.Average_Daily_Demand
                 * c.Target_Days_of_Supply
             ) > c.Inventory_Level
        THEN CEILING(
            a.Average_Daily_Demand
            * c.Target_Days_of_Supply
            - c.Inventory_Level
        )
        ELSE 0
    END AS Recommended_Order_Qty

FROM coverage_target c

LEFT JOIN average_demand a
    ON c.Store_ID = a.Store_ID
    AND c.Product_ID = a.Product_ID

WHERE c.rn = 1;

-- P25 (Reorder_DOS_Threshold) → menentukan kapan perlu reorder.
-- P75 (Target_Days_of_Supply) → membantu menentukan berapa banyak stok yang ingin tersedia.
-- Jadi, P25 itu seperti alarm untuk mulai mengisi stok, sedangkan P75 menjadi dasar target stok yang ingin dicapai.
