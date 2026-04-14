"""
Export mart tables to CSV for Looker Studio
"""
import duckdb
import os
from pathlib import Path

# Set up paths
project_root = Path(__file__).parent
customer_experience_dir = project_root / "customer_experience"
exports_dir = project_root / "exports"

# Ensure exports directory exists
exports_dir.mkdir(exist_ok=True)

# Connect to DuckDB
db_path = customer_experience_dir / "dev.duckdb"
conn = duckdb.connect(str(db_path))

# Export tables to CSV
tables = ["fct_customer_orders", "dim_customer_experience"]

for table in tables:
    output_file = exports_dir / f"{table}.csv"
    query = f"COPY (SELECT * FROM {table}) TO '{output_file}' (FORMAT CSV, HEADER TRUE)"
    conn.execute(query)
    print(f"Exported {table} to {output_file}")

conn.close()
print("\n All tables exported successfully to ./exports/")
