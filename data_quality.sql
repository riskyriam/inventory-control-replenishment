--- Mengecek jumlah row data
SELECT COUNT(*) AS Row_Numbers FROM dbo.sales_data

--- Mengecek duplikat berdasarkan data grain
SELECT
    Date,
    Store_ID,
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.sales_data
GROUP BY
    Date,
    Store_ID,
    Product_ID
HAVING COUNT(*) > 1;

--- Cek nilai yang tidak wajar
SELECT *
FROM dbo.sales_data
WHERE Inventory_Level < 0
   OR Units_Sold < 0
   OR Units_Ordered < 0
   OR Demand < 0;

--- konsistensi tanggal
SELECT
    MIN(Date) AS First_Date,
    MAX(Date) AS Last_Date,
    COUNT(DISTINCT Date) AS Total_Dates
FROM dbo.sales_data;
