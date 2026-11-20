
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 15),

          // Profil rasmi
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.lightBlue,
                child: Icon(
                  Icons.person,
                  size: 55,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Foydalanuvchi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Center(
            child: Text(
              'user@example.com',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Hisob sozlamalari',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 12),

          _profileItem(
            icon: Icons.person_outline,
            title: 'Shaxsiy ma’lumotlar',
            subtitle: 'Profil ma’lumotlarini boshqarish',
            onTap: () => _showMessage(context, 'Shaxsiy ma’lumotlar'),
          ),

          _profileItem(
            icon: Icons.notifications_outlined,
            title: 'Bildirishnomalar',
            subtitle: 'Xabarnoma sozlamalari',
            onTap: () => _showMessage(context, 'Bildirishnomalar'),
          ),

          _profileItem(
            icon: Icons.lock_outline,
            title: 'Xavfsizlik',
            subtitle: 'Hisob xavfsizligi',
            onTap: () => _showMessage(context, 'Xavfsizlik'),
          ),

          const SizedBox(height: 20),

          const Text(
            'Boshqa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 12),

          _profileItem(
            icon: Icons.info_outline,
            title: 'Ilova haqida',
            subtitle: 'Daily_expenses haqida ma’lumot',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Daily_expenses',
                applicationVersion: '1.0.0',
                applicationLegalese:
                'Shaxsiy xarajatlarni boshqarish ilovasi',
              );
            },
          ),

          const SizedBox(height: 25),

          // Tizimdan chiqish
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Tizimdan chiqish'),
                  content: const Text(
                    'Haqiqatan ham tizimdan chiqmoqchimisiz?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('Bekor qilish'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _showMessage(
                          context,
                          'Chiqish funksiyasi keyin ulanadi',
                        );
                      },
                      child: const Text(
                        'Ha, chiqish',
                        style: TextStyle(color: AppColors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.red,
            ),
            label: const Text(
              'Tizimdan chiqish',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              side: const BorderSide(color: AppColors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Daily_expenses v1.0.0',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _profileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.secondaryText,
        ),
        onTap: onTap,
      ),
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message — bu funksiya keyin ulanadi.'),
      ),
    );
  }
}
