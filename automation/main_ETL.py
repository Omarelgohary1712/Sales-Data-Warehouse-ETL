from execute_sql import execute_sql
from Cleaned_Silver import clean_data


def main():

    print("=" * 50)
    print("Sales Data Warehouse ETL Pipeline")
    print("=" * 50)

    print("\nStep 1: Loading Bronze Layer...")
    execute_sql("/Users/HP/Downloads/SalesDW/BronzeLayer_SDW.sql")

    print("\nStep 2: Cleaning Data & Loading Silver...")
    clean_data()

    print("\nStep 3: Loading Gold Layer...")
    execute_sql("/Users/HP/Downloads/SalesDW/GoldSDW.sql")

    print("\nETL Pipeline Finished Successfully!")


if __name__ == "__main__":
    main()