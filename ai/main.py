
import pandas as pd
from pathlib import Path

data_folder = Path("data")

products_file = data_folder / "products.csv"
expenses_file = data_folder / "expenses.csv"

# Mahsulotlar katalogini tekshirish
products = pd.read_csv(products_file)

print("MAHSULOTLAR KATALOGI")
print(products.to_string(index=False))

# Xarajatlar faylini tekshirish
expenses = pd.read_csv(expenses_file)

print("\nXARAJATLAR FAYLI")
print(expenses.to_string(index=False))

print("\nXarajatlar soni:", len(expenses))
print("Xarajatlar ustunlari:", list(expenses.columns))
print("Bo'sh qiymatlar:", expenses.isnull().sum().sum())



# AI qoidalari faylini tekshirish
rules_file = data_folder / "ai_product_rules.csv"
rules = pd.read_csv(rules_file)

print("\nAI MAHSULOT QOIDALARI")
print(rules.to_string(index=False))

print("\nAI qoidalari soni:", len(rules))
print("Bo'sh qiymatlar:", rules.isnull().sum().sum())
