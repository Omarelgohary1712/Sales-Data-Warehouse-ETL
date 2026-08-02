import pandas as pd
import numpy as np
from sqlalchemy import create_engine
from config import SERVER, DATABASE


engine = create_engine(
    f"mssql+pyodbc://@{SERVER}/{DATABASE}"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)

def clean_data():
    df_silver = pd.read_sql(
    "SELECT * FROM bronze.BSales",
    engine
    )
    df_silver.loc[df_silver["CostPrice"]<0,"CostPrice"]=np.nan
    df_silver.loc[df_silver["Age"]<0 ,"Age"]=np.nan
    df_silver.loc[df_silver["Age"]>100 ,"Age"]=np.nan
    df_silver["SaleDate"]=pd.to_datetime(df_silver["SaleDate"],errors="coerce")
    df_silver["Age"]=df_silver["Age"].astype("Int64")
    df_silver["CostPrice"]=df_silver["CostPrice"].astype("Int64")
    df_silver.loc[df_silver["Quantity"]<=0 ,"Quantity"]=np.nan
    df_silver["Discount"] = df_silver["Discount"].fillna(0)
    df_silver["Discount"] = df_silver["Discount"].astype("Int64")
    df_silver["City"] = df_silver["City"].str.title()
    df_silver["Brand"] = df_silver["Brand"].str.title()
    df_silver["Quantity"] = df_silver["Quantity"].astype("Int64")
    df_silver.loc[df_silver["CustomerID"] == 2778, "Age"] = 53



    with engine.begin() as conn:
     conn.exec_driver_sql("TRUNCATE TABLE Silver.Sales")


    df_silver.to_sql(
    name="Sales",
    schema="Silver",
    con=engine,
    if_exists="append",
    index=False
    )  


    print(f"Loaded {len(df_silver)} rows into Silver.Sales")
    print("Silver Layer Loaded Successfully")
    
if __name__ == "__main__":
    clean_data()    