# inventory-control-replenishment
Inventory Control & Replenishment Planning

Project Overview
Proyek ini bertujuan mempelajari penerapan inventory control melalui analisis demand, inventory level, ABC Analysis, dan demand-based replenishment menggunakan SQL Server dan Excel.

Objectives
- Mengidentifikasi pola demand dan kondisi persediaan.
- Mengklasifikasikan produk berdasarkan nilai konsumsi menggunakan ABC Analysis.
- Menyusun rekomendasi waktu dan jumlah pemesanan berdasarkan data historis.

Dataset
Source: Retail Store Inventory and Demand Forecasting — Kaggle (link: https://www.kaggle.com/datasets/atomicd/retail-store-inventory-and-demand-forecasting)
Period: 2022–2024

Data grain: Date × Store × Product

Tools
- SQL Server — data preparation, analysis, dan replenishment calculation.
- Microsoft Excel — ABC Analysis dan perhitungan nilai konsumsi.

Methodology
- Data Quality & Preparation
- Demand & Inventory Overview
- ABC Analysis
- Demand-Based Replenishment Planning

Limitations

Dataset tidak menyediakan informasi lead time aktual. Oleh karena itu, replenishment menggunakan pendekatan berbasis data historis dan belum mempertimbangkan lead time serta safety stock. Hasilnya merupakan rekomendasi simulasi, bukan sistem replenishment operasional.
