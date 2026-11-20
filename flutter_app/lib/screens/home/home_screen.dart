
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../expenses/add_expense_screen.dart';
import '../expenses/expenses_screen.dart';
import '../budget/budget_screen.dart';
import '../statistics/statistics_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Daily_expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xush kelibsiz! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Xarajatlaringizni nazorat qiling',
              style: TextStyle(color: AppColors.secondaryText),
            ),

            const SizedBox(height: 24),

            // OYLIK XARAJAT
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Joriy oy xarajatlari',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  Text(
                    '0 so‘m',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    '2026-yil noyabr',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BUGUNGI XARAJAT
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    title: 'Bugungi xarajat',
                    value: '0 so‘m',
                    icon: Icons.today_outlined,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    title: 'Oylik xarajat',
                    value: '0 so‘m',
                    icon: Icons.calendar_month_outlined,
                    iconColor: AppColors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              'Tezkor amallar',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.add_circle_outline,
                    title: 'Xarajat qo‘shish',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AddExpenseScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.receipt_long_outlined,
                    title: 'Xarajatlar',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ExpensesScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.bar_chart,
                    title: 'Statistika',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const StatisticsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.auto_awesome,
                    title: 'AI tahlil',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'AI tahlil sahifasini keyingi bosqichda yaratamiz.',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // BUDJET
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budjet va limitlar',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BudgetScreen(),
                      ),
                    );
                  },
                  child: const Text('Batafsil'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BudgetScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.track_changes,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Oylik xarajat limiti',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    LinearProgressIndicator(
                      value: 0,
                      minHeight: 9,
                      backgroundColor: AppColors.lightBlue,
                      color: AppColors.primary,
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Limitni belgilash va boshqarish uchun bosing',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // AI TAVSIYASI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI tavsiyasi',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Xarajatlaringizni qayd eting. '
                              'AI ularni tahlil qilib, '
                              'tejash bo‘yicha tavsiyalar beradi.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // PASTKI NAVIGATSIYA
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExpensesScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatisticsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Bosh sahifa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Xarajatlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Statistika',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// MA'LUMOT KARTASI
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 25),
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
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

// TEZKOR AMAL TUGMASI
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
