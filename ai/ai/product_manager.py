
import pandas as pd
from pathlib import Path
from ai.rules_engine import analyze_product

BASE_DIR = Path(__file__).resolve().parent.parent
PRODUCTS_FILE = BASE_DIR / "data" / "products.csv"
RULES_FILE = BASE_DIR / "data" / "ai_product_rules.csv"

ALLOWED_STATUSES = [
    "Kerak",
    "Kerak emas",
    "Unchalik zarur emas"
]


def add_product(product_name, category):
    product_name = product_name.strip()
    category = category.strip()

    if not product_name or not category:
        print("Mahsulot nomi va kategoriyasini kiriting.")
        return

    products = pd.read_csv(PRODUCTS_FILE)

    mavjud = products["product_name"].astype(str).str.strip().str.casefold()

    if product_name.casefold() in mavjud.values:
        print("Bu mahsulot katalogda mavjud.")
        return

    new_id = (
        int(products["product_id"].max()) + 1
        if not products.empty else 1
    )

    new_product = pd.DataFrame([{
        "product_id": new_id,
        "product_name": product_name,
        "category": category
    }])

    products = pd.concat([products, new_product], ignore_index=True)
    products.to_csv(PRODUCTS_FILE, index=False)

    print(f"\n{product_name} katalogga qo‘shildi!")

    # Mahsulotni mavjud AI qoidalari orqali tahlil qilish
    result = analyze_product(product_name, category)

    print("\nMAHSULOT TAHLILI")
    print("-" * 35)
    print(f"Mahsulot: {result['product']}")
    print(f"Kategoriya: {result['category']}")
    print(f"Status: {result['status']}")
    print(f"Izoh: {result['reason']}")


def add_ai_rule(product_name, status, reason):
    product_name = product_name.strip()
    status = status.strip()
    reason = reason.strip()

    if not product_name or not reason:
        print("Mahsulot nomi va izohni kiriting.")
        return

    if status not in ALLOWED_STATUSES:
        print("Noto‘g‘ri status kiritildi.")
        return

    rules = pd.read_csv(RULES_FILE)

    mavjud = rules["product_name"].astype(str).str.strip().str.casefold()

    if product_name.casefold() in mavjud.values:
        print("Bu mahsulot uchun qoida mavjud.")
        return

    new_rule = pd.DataFrame([{
        "product_name": product_name,
        "status": status,
        "reason": reason
    }])

    rules = pd.concat([rules, new_rule], ignore_index=True)
    rules.to_csv(RULES_FILE, index=False)

    print(f"{product_name} uchun qoida saqlandi!")


if __name__ == "__main__":
    print("1. Mahsulot qo‘shish va tahlil qilish")
    print("2. Mahsulot uchun AI qoidasi qo‘shish")

    tanlov = input("Tanlovingiz (1 yoki 2): ")

    if tanlov == "1":
        nom = input("Mahsulot nomi: ")
        kategoriya = input("Mahsulot kategoriyasi: ")
        add_product(nom, kategoriya)

    elif tanlov == "2":
        nom = input("Mahsulot nomi: ")
        status = input(
            "Status (Kerak / Kerak emas / Unchalik zarur emas): "
        )
        izoh = input("Izoh: ")

        add_ai_rule(nom, status, izoh)

    else:
        print("Noto‘g‘ri tanlov!")
