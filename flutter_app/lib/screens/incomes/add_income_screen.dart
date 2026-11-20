import 'package:flutter/material.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    amountController.dispose();
    sourceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveIncome() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daromad muvaffaqiyatli saqlandi'),
        ),
      );

      Navigator.pop(context);
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text(
          'Daromad qo‘shish',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daromad summasi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masalan: 5000000',
                  suffixText: 'so‘m',
                  prefixIcon: const Icon(
                    Icons.payments_outlined,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Summani kiriting';
                  }

                  final amount = double.tryParse(value);

                  if (amount == null) {
                    return 'Summani raqamda kiriting';
                  }

                  if (amount <= 0) {
                    return 'Summa 0 dan katta bo‘lishi kerak';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Daromad manbasi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: sourceController,
                decoration: InputDecoration(
                  hintText: 'Masalan: Ish haqi',
                  prefixIcon: const Icon(
                    Icons.work_outline,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Daromad manbasini kiriting';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Sana',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: selectDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatDate(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Izoh',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Daromad haqida qo‘shimcha maʼlumot...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: Icon(
                      Icons.notes_outlined,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: saveIncome,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Daromadni saqlash',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}