
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/database_helper.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'Barchasi';
  bool isLoading = true;

  List<Map<String, dynamic>> expenses = [];

  final List<String> categories = [
    'Barchasi',
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

  // KATEGORIYAGA MOS ICON
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Oziq-ovqat':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_bus;
      case 'Xaridlar':
        return Icons.shopping_bag;
      case 'Ta’lim':
        return Icons.school;
      case 'Uy-ro‘zg‘or':
        return Icons.home;
      case 'Sog‘liq':
        return Icons.health_and_safety;
      case 'Ko‘ngilochar':
        return Icons.movie;
      case 'Aloqa':
        return Icons.phone_android;
      case 'Kiyim-kechak':
        return Icons.checkroom;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // SQLITE BAZADAN XARAJATLARNI OLISH
  Future<void> loadExpenses() async {
    try {
      final data = await DatabaseHelper.instance.getExpenses();

      if (!mounted) return;

      setState(() {
        expenses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Xarajatlarni yuklashda xatolik: $e'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  // QIDIRUV VA KATEGORIYA FILTR
  List<Map<String, dynamic>> get filteredExpenses {
    final query = searchController.text.trim().toLowerCase();

    return expenses.where((expense) {
      final category = expense['category']?.toString() ?? '';
      final title = expense['title']?.toString().toLowerCase() ?? '';
      final description =
          expense['description']?.toString().toLowerCase() ?? '';

      final matchesCategory = selectedCategory == 'Barchasi' ||
          category == selectedCategory;

      final matchesSearch =
          title.contains(query) || description.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // JAMI XARAJAT
  double get totalExpenses {
    return filteredExpenses.fold<double>(
      0,
          (sum, expense) => sum + (expense['amount'] as num).toDouble(),
    );
  }

  // SUMMANI FORMATLASH
  String formatAmount(double amount) {
    final value = amount.toInt().toString();
    final result = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      result.write(value[i]);

      final remaining = value.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        result.write(' ');
      }
    }

    return result.toString();
  }

  // SANANI FORMATLASH
  String formatDate(dynamic dateValue) {
    if (dateValue == null) return '';

    DateTime? date;

    try {
      date = DateTime.parse(dateValue.toString());
    } catch (_) {
      return dateValue.toString();
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // XARAJAT QO'SHISH
  Future<void> openAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (result == true) {
      await loadExpenses();
    }
  }

  // XARAJATNI TAHRIRLASH
  Future<void> editExpense(Map<String, dynamic> expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          expense: expense,
        ),
      ),
    );

    if (result == true) {
      await loadExpenses();
    }
  }

  // XARAJATNI O'CHIRISH
  Future<void> removeExpense(Map<String, dynamic> expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Xarajatni o‘chirish',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${expense['title']}" xarajatini o‘chirmoqchimisiz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('O‘chirish'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await DatabaseHelper.instance.deleteExpense(
        expense['id'] as int,
      );

      await loadExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xarajat o‘chirildi'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O‘chirishda xatolik: $e'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  // XARAJAT AMALLARI MENYUSI
  Widget expenseMenu(Map<String, dynamic> expense) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.secondaryText,
      ),
      tooltip: 'Amallar',
      onSelected: (value) {
        if (value == 'edit') {
          editExpense(expense);
        } else if (value == 'delete') {
          removeExpense(expense);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              Text('Tahrirlash'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text('O‘chirish'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredExpenses;

    return Scaffold(
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        title: const Text(
          'Xarajatlar tarixi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),

      body: Column(
        children: [
          // QIDIRUV VA FILTRLAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // JAMI XARAJATLAR KARTASI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.darkBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ko‘rsatilgan xarajatlar jami',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        '${formatAmount(totalExpenses)} so‘m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${items.length} ta xarajat',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // QIDIRUV
                TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Xarajatni qidirish...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // KATEGORIYA FILTR
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategoriya bo‘yicha filtr',
                    prefixIcon: const Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
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
              ],
            ),
          ),

          // XARAJATLAR RO'YXATI
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 55,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Xarajatlar topilmadi',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final expense = items[index];

                final amount =
                (expense['amount'] as num).toDouble();

                final category =
                    expense['category']?.toString() ?? 'Boshqa';

                final description =
                    expense['description']?.toString() ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.025),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // KATEGORIYA ICONI
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          getCategoryIcon(category),
                          color: AppColors.primary,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 13),

                      // XARAJAT MA'LUMOTLARI
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              expense['title'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.text,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              description.isEmpty
                                  ? category
                                  : description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              formatDate(expense['expense_date']),
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // SUMMA VA AMALLAR
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '-${formatAmount(amount)}',
                            style: const TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          expenseMenu(expense),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // XARAJAT QO'SHISH TUGMASI
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Xarajat qo‘shish'),
        onPressed: openAddExpense,
      ),
    );
  }
}
