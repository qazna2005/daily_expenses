
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Keyin jamoadoshingning backend manzilini kiritamiz.
  static const String baseUrl = 'http://192.168.1.10:8000';

  static Future<List<dynamic>> getExpenses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses/'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data;
      }

      throw Exception('Backend xarajatlar ro‘yxatini qaytarmadi.');
    }

    throw Exception(
      'Xarajatlarni olishda xato: ${response.statusCode}',
    );
  }

  static Future<bool> addExpense({
    required String title,
    required int amount,
    required String category,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/expenses/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'amount': amount,
        'category': category,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    throw Exception(
      'Xarajatni saqlashda xato: ${response.statusCode} ${response.body}',
    );
  }
}
