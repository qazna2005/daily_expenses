
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  final Map<String, dynamic>? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Oziq-ovqat';
  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

  bool get isEditing => widget.expense != null;

  final List<String> categories = [
    'Oziq-ovqat',
    'Transport',
    'Xaridlar',
    'Ta’lim',
    'Uy-ro‘zg‘or',
    'Sog‘liq',
    'Ko‘ngilochar',
    'Aloqa',
    'Kiyim-kechak',
    'Boshqa',
  ];

  @override
  void initState() {
    super.initState();

    // Agar tahrirlash bo'lsa, eski ma'lumotlarni formaga chiqaramiz
    if (widget.expense != null) {
      final expense = widget.expense!;

      titleController.text = expense['title']?.toString() ?? '';
      amountController.text = expense['amount']?.toString() ?? '';
      descriptionController.text =
          expense['description']?.toString() ?? '';

      selectedCategory =
          expense['category']?.toString() ?? 'Oziq-ovqat';

      try {
        selectedDate = DateTime.parse(
          expense['expense_date'].toString(),
        );
      } catch (_) {
        selectedDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // SANANI TANLASH
  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // XARAJATNI SAQLASH YOKI YANGILASH
  Future<void> saveExpense() async {
    if (isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      amountController.text.trim().replaceAll(',', '.'),
    );

    final now = DateTime.now();

    final expenseData = <String, dynamic>{
      'title': titleController.text.trim(),
      'amount': amount,
      'category': selectedCategory,
      'description': descriptionController.text.trim(),
      'expense_date': selectedDate.toIso8601String(),
      'sync_status': 0,
      'is_deleted': 0,
    };

    setState(() {
      isSaving = true;
    });

    try {
      if (isEditing) {
        final oldExpense = widget.expense!;

        await DatabaseHelper.instance.updateExpense(
          oldExpense['id'] as int,
          expenseData,
        );
      } else {
        expenseData['created_at'] = now.toIso8601String();

        await DatabaseHelper.instance.insertExpense(expenseData);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Xarajat muvaffaqiyatli yangilandi!'
                : 'Xarajat muvaffaqiyatli saqlandi!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saqlashda xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // SANANI FORMATLASH
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // INPUT DIZAYNI
  InputDecoration fieldDecoration({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixText: suffix,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  // BO'LIM SARLAVHASI
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Xarajatni tahrirlash' : 'Xarajat qo‘shish',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SARLAVHA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit_note : Icons.add_card,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEditing
                            ? 'Xarajat ma’lumotlarini o‘zgartiring'
                            : 'Yangi xarajat ma’lumotlarini kiriting',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // XARAJAT NOMI
              sectionTitle('Xarajat nomi'),
              TextFormField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: fieldDecoration(
                  hint: 'Masalan: Non, Sut, Avtobus',
                  icon: Icons.shopping_bag_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Xarajat nomini kiriting';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 22),

              // SUMMA
              sectionTitle('Xarajat summasi'),
              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: fieldDecoration(
                  hint: 'Masalan: 35000',
                  icon: Icons.payments_outlined,
                  suffix: 'so‘m',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Summani kiriting';
                  }

                  final amount = double.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );

                  if (amount == null || !amount.isFinite) {
                    return 'Summani raqamda kiriting';
                  }

                  if (amount <= 0) {
                    return 'Summa 0 dan katta bo‘lishi kerak';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 22),

              // KATEGORIYA
              sectionTitle('Kategoriya'),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: fieldDecoration(
                  hint: 'Kategoriyani tanlang',
                  icon: Icons.category_outlined,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 22),

              // SANA
              sectionTitle('Xarajat sanasi'),
              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatDate(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // IZOH
              sectionTitle('Izoh (ixtiyoriy)'),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: fieldDecoration(
                  hint: 'Xarajat haqida qo‘shimcha ma’lumot...',
                  icon: Icons.notes_outlined,
                ),
              ),

              const SizedBox(height: 30),

              // SAQLASH / YANGILASH TUGMASI
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : saveExpense,
                  icon: isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    isEditing
                        ? Icons.check_circle_outline
                        : Icons.save_outlined,
                  ),
                  label: Text(
                    isSaving
                        ? 'Saqlanmoqda...'
                        : isEditing
                        ? 'O‘zgarishlarni saqlash'
                        : 'Xarajatni saqlash',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
