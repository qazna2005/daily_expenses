
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController amountController = TextEditingController();

  String selectedCategory = 'Oziq-ovqat';

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

  // Namunaviy ma'lumotlar.
  // Keyinchalik backenddan olinadi.
  final Map<String, double> categoryBudgets = {
    'Oziq-ovqat': 1000000,
    'Transport': 300000,
    'Xaridlar': 500000,
    'Ta’lim': 400000,
    'Uy-ro‘zg‘or': 300000,
    'Sog‘liq': 300000,
    'Ko‘ngilochar': 200000,
    'Aloqa': 150000,
    'Kiyim-kechak': 300000,
    'Boshqa': 200000,
  };

  final Map<String, double> categorySpent = {
    'Oziq-ovqat': 750000,
    'Transport': 120000,
    'Xaridlar': 180000,
    'Ta’lim': 100000,
    'Uy-ro‘zg‘or': 50000,
    'Sog‘liq': 0,
    'Ko‘ngilochar': 80000,
    'Aloqa': 50000,
    'Kiyim-kechak': 0,
    'Boshqa': 20000,
  };

  double get totalBudget =>
      categoryBudgets.values.fold(0, (sum, value) => sum + value);

  double get totalSpent =>
      categorySpent.values.fold(0, (sum, value) => sum + value);

  double get remainingAmount => totalBudget - totalSpent;

  double get progress {
    if (totalBudget <= 0) return 0;
    return (totalSpent / totalBudget).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

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

  void saveBudget() {
    final amount = double.tryParse(
      amountController.text.trim().replaceAll(',', '.'),
    );

    if (amount == null || !amount.isFinite || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budjet summasini to‘g‘ri kiriting'),
        ),
      );
      return;
    }

    setState(() {
      categoryBudgets[selectedCategory] = amount;
    });

    amountController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedCategory budjeti yangilandi'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverBudget = totalSpent > totalBudget;
    final isNearLimit = progress >= 0.8;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Budjet va limitlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Moliyaviy rejangiz',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Xarajatlaringizni rejalashtiring va nazorat qiling.',
              style: TextStyle(color: AppColors.secondaryText),
            ),

            const SizedBox(height: 22),

            // Umumiy budjet kartasi
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Umumiy oylik limit',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${formatAmount(totalBudget)} so‘m',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sarflangan',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        '${(totalBudget > 0 ? totalSpent / totalBudget * 100 : 0).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.white30,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sarflangan va qolgan summa
            Row(
              children: [
                Expanded(
                  child: _BudgetInfoCard(
                    title: 'Sarflangan',
                    amount: totalSpent,
                    icon: Icons.trending_up,
                    color: AppColors.orange,
                    formatAmount: formatAmount,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _BudgetInfoCard(
                    title: isOverBudget ? 'Limitdan oshgan' : 'Qolgan',
                    amount: remainingAmount.abs(),
                    icon: isOverBudget
                        ? Icons.warning_amber_rounded
                        : Icons.savings_outlined,
                    color: isOverBudget ? AppColors.red : AppColors.green,
                    formatAmount: formatAmount,
                    prefix: isOverBudget ? '+' : '',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Ogohlantirish
            if (isOverBudget || isNearLimit)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isOverBudget
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: isOverBudget ? AppColors.red : AppColors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isOverBudget
                            ? 'Umumiy budjet chegarasidan oshdingiz. Xarajatlarni qayta ko‘rib chiqing.'
                            : 'Diqqat! Umumiy budjetingizning 80 foiziga yetdingiz.',
                        style: TextStyle(
                          color: isOverBudget
                              ? Colors.red.shade800
                              : Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            const Text(
              'Kategoriyalar bo‘yicha limitlar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 12),

            // Kategoriyalar ro'yxati
            ...categories.map((category) {
              final budget = categoryBudgets[category] ?? 0;
              final spent = categorySpent[category] ?? 0;
              final ratio = budget > 0
                  ? (spent / budget).clamp(0.0, 1.0)
                  : 0.0;

              final over = spent > budget;
              final color = over ? AppColors.red : AppColors.primary;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Text(
                          '${formatAmount(spent)} / ${formatAmount(budget)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor: AppColors.lightBlue,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        over ? 'Limitdan oshgan' : 'Limitning ${(ratio * 100).round()}%',
                        style: TextStyle(
                          color: over ? AppColors.red : AppColors.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Yangi limit belgilash
            const Text(
              'Limitni o‘zgartirish',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategoriya',
                prefixIcon: const Icon(
                  Icons.category_outlined,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
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

            const SizedBox(height: 12),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Yangi oylik limit',
                hintText: 'Masalan: 1000000',
                suffixText: 'so‘m',
                prefixIcon: const Icon(
                  Icons.payments_outlined,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton.icon(
                onPressed: saveBudget,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Limitni saqlash',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetInfoCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final String Function(double) formatAmount;
  final String prefix;

  const _BudgetInfoCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.formatAmount,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$prefix${formatAmount(amount)} so‘m',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
