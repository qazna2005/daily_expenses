# Daily_expenses — AI texnik talablari

## 1. Loyihaning maqsadi

Foydalanuvchining kundalik xarajatlarini hisoblash va sotib olingan mahsulotlarni zarurligi hamda sog‘liq uchun xavfi bo‘yicha baholash.

## 2. AI qismining vazifalari

- Mahsulotni nomi bo‘yicha aniqlash.
- Mahsulotni kerakli, ixtiyoriy yoki vaziyatga bog‘liq deb baholash.
- Sog‘liq uchun xavf darajasini ko‘rsatish.
- Har bir baholash uchun tushunarli izoh berish.
- Qoidasi mavjud bo‘lmagan mahsulotni aniqlanmagan deb ko‘rsatish.

## 3. Xarajatlarni hisoblash

- Mahsulot narxini foydalanuvchi qo‘lda kiritadi.
- AI narxlarni o‘rganmaydi va mahsulotning zarurligini narxiga qarab belgilamaydi.
- Dastur xarajatlar jami summasini hisoblaydi.
- Keyinchalik kunlik, haftalik va oylik hisobotlarni qo‘shish mumkin.

## 4. Ma’lumotlar fayllari

- `data/products.csv` — mahsulotlar katalogi.
- `data/expenses.csv` — foydalanuvchi xarajatlari.
- `data/ai_product_rules.csv` — mahsulotlarni baholash qoidalari.

## 5. AI modullari

- `ai/rules_engine.py` — mahsulotni qoidalar asosida baholash.
- `ai/expense_analyzer.py` — xarajatlarni AI qoidalari bilan bog‘lash.
- `tests/test_rules_engine.py` — baholash funksiyasini tekshirish.

## 6. Baholash qoidalari

- `essential` — kerakli.
- `optional` — ixtiyoriy.
- `contextual` — vaziyatga bog‘liq.
- `health_risk = high` — sog‘liq uchun xavf yuqori.
- Qoidasi mavjud bo‘lmagan mahsulot — aniqlanmagan.

Mahsulotning zarurligi va sog‘liq uchun xavfi alohida baholanadi. Masalan, dori vositasini faqat nomiga qarab keraksiz deb bo‘lmaydi.

## 7. Boshqa qismlar bilan integratsiya

- Flutter ilovasi foydalanuvchi interfeysini taqdim etadi.
- Backend ma’lumotlarni qabul qilish, saqlash va qaytarishga xizmat qiladi.
- Telegram bot xarajatlarni kiritish va hisobotlarni olish imkoniyatini berishi mumkin.
- AI qismi mahsulotni baholash natijasi va izohini qaytaradi.

Uchala qism bir xil mahsulot identifikatori, kategoriya va xarajatlar tuzilmasidan foydalanishi kerak. Yakuniy API va ma’lumotlar tuzilmasi jamoa bilan kelishiladi.

## 8. Hozirgi holat

- Python muhiti va kerakli kutubxonalar o‘rnatilgan.
- CSV fayllari Python orqali o‘qilmoqda.
- 12 ta mahsulot uchun boshlang‘ich AI qoidalari mavjud.
- Mahsulotni baholash funksiyasi ishlamoqda.
- 4 ta avtomatik sinov muvaffaqiyatli o‘tgan.
- 10 ta xarajat uchun jami 507 000 so‘m hisoblangan.

## 9. Keyingi takomillashtirish ishlari

- Yangi mahsulotlarni katalogga qo‘shish mexanizmini yaratish.
- Mahsulot kategoriyalarini jamoaning umumiy ma’lumotlar bazasi bilan moslashtirish.
- AI natijalarini backend API orqali uzatish.
- Qo‘shimcha sinovlar va xatoliklarni tekshirish.
