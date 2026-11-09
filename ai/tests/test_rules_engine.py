
from ai.rules_engine import analyze_product


def test_olma_kerak():
    natija = analyze_product("Olma")
    assert natija["status"] == "Kerak"


def test_aroq_kerak_emas():
    natija = analyze_product("Aroq")
    assert natija["status"] == "Kerak emas"


def test_kino_unchalik_zarur_emas():
    natija = analyze_product("Kino chiptasi")
    assert natija["status"] == "Unchalik zarur emas"


def test_anor_kerak():
    natija = analyze_product("Anor")
    assert natija["status"] == "Kerak"


def test_nomalum_mahsulot():
    natija = analyze_product("QWERTY")
    assert natija["category"] == "Aniqlanmagan"
    assert natija["status"] in [
        "Kerak",
        "Kerak emas",
        "Unchalik zarur emas",
    ]


if __name__ == "__main__":
    test_olma_kerak()
    test_aroq_kerak_emas()
    test_kino_unchalik_zarur_emas()
    test_anor_kerak()
    test_nomalum_mahsulot()

    print("Barcha AI sinovlari muvaffaqiyatli o'tdi!")
