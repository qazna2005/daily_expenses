
import pandas as pd
from pathlib import Path
from ai.rules_engine import analyze_product

BASE_DIR = Path(__file__).resolve().parent.parent
EXPENSES_FILE = BASE_DIR / "data" / "expenses.csv"


def analyze_expenses():
    """Xarajatlarni hisoblaydi va mahsulotlarni baholaydi."""
    expenses = pd.read_csv(EXPENSES_FILE)

    total_amount = expenses["amount"].sum()

    print("XARAJATLAR TAHLILI")
    print("=" * 50)

    for _, expense in expenses.iterrows():
        result = analyze_product(str(expense["product"]))

        print(f"\nMahsulot: {expense['product']}")
        print(f"Kategoriya: {result['category']}")
        print(f"Narxi: {expense['amount']:,.0f} so'm")
        print(f"Status: {result['status']}")
        print(f"Izoh: {result['reason']}")

    print("\n" + "=" * 50)
    print(f"Jami xarajat: {total_amount:,.0f} so'm")
    print(f"Xarajatlar soni: {len(expenses)}")


if __name__ == "__main__":
    analyze_expenses()
