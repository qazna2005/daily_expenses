
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
RULES_FILE = BASE_DIR / "data" / "ai_product_rules.csv"
PRODUCTS_FILE = BASE_DIR / "data" / "products.csv"

ALLOWED_STATUSES = [
    "Kerak",
    "Kerak emas",
    "Unchalik zarur emas",
]


def load_rules():
    return pd.read_csv(RULES_FILE)


def load_products():
    return pd.read_csv(PRODUCTS_FILE)


def get_product_category(product_name):
    products = load_products()

    found = products[
        products["product_name"].astype(str).str.strip().str.casefold()
        == product_name.strip().casefold()
    ]

    if found.empty:
        return "Aniqlanmagan"

    return str(found.iloc[0]["category"]).strip()


def analyze_product(product_name, category=None):
    product_name = product_name.strip()
    rules = load_rules()

    found = rules[
        rules["product_name"].astype(str).str.strip().str.casefold()
        == product_name.casefold()
    ]

    if not found.empty:
        rule = found.iloc[0]
        status = str(rule["status"]).strip()

        if status not in ALLOWED_STATUSES:
            status = "Unchalik zarur emas"

        return {
            "product": str(rule["product_name"]),
            "category": category or get_product_category(product_name),
            "status": status,
            "reason": str(rule["reason"]),
        }

    product_category = category or get_product_category(product_name)

    if product_category != "Aniqlanmagan":
        return {
            "product": product_name,
            "category": product_category,
            "status": "Unchalik zarur emas",
            "reason": (
                "Bu mahsulot uchun maxsus qoida mavjud emas. "
                "Aniq baholash uchun qoida kiritish kerak."
            ),
        }

    return {
        "product": product_name,
        "category": "Aniqlanmagan",
        "status": "Unchalik zarur emas",
        "reason": (
            "Mahsulot katalogda va qoidalar faylida topilmadi. "
            "Uni tekshirib, mos qoida kiritish kerak."
        ),
    }


if __name__ == "__main__":
    test_products = [
        "Olma",
        "Aroq",
        "Kino chiptasi",
        "Mango",
        "Anor",
        "QWERTY",
    ]

    for name in test_products:
        result = analyze_product(name)
        print(f"\nMahsulot: {result['product']}")
        print(f"Kategoriya: {result['category']}")
        print(f"Status: {result['status']}")
        print(f"Izoh: {result['reason']}")
