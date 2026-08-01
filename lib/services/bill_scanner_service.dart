import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/transactionproflie.dart';

class BillScannerService {
  static Future<TransactionProfile?> scanBill(File imageFile) async {
    final endpoint = dotenv.env['AI_API_ENDPOINT'];
    if (endpoint == null || endpoint.isEmpty) {
      throw Exception('Chưa cấu hình AI_API_ENDPOINT trong file .env. Vui lòng thêm biến này.');
    }

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Gửi POST request tới API
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
          'prompt': 'Analyze this receipt and return a JSON object with: amount (number), time (ISO8601 format), title (string). Only output raw JSON.',
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        String rawJson = '';
        
        // Hỗ trợ xử lý các định dạng phổ biến của LLM API
        if (data is Map && data.containsKey('choices')) {
            // Định dạng tương tự OpenAI
            rawJson = data['choices'][0]['message']['content'];
        } else if (data is Map && data.containsKey('candidates')) {
            // Định dạng tương tự Gemini (REST)
            rawJson = data['candidates'][0]['content']['parts'][0]['text'];
        } else if (data is Map && (data.containsKey('amount') || data.containsKey('time'))) {
            // Định dạng trực tiếp
            rawJson = response.body; 
        } else if (data is Map && data.containsKey('response')) {
            // Định dạng Ollama
            rawJson = data['response'];
        } else if (data is String) {
            rawJson = data;
        } else {
            rawJson = jsonEncode(data);
        }

        // Xóa block code markdown nếu có
        rawJson = rawJson.replaceAll('```json', '').replaceAll('```', '').trim();

        final parsedJson = jsonDecode(rawJson);

        final amount = (parsedJson['amount'] as num?)?.toDouble() ?? 0.0;
        final timeStr = parsedJson['time'] as String?;
        final time = timeStr != null ? DateTime.tryParse(timeStr) ?? DateTime.now() : DateTime.now();
        final title = parsedJson['title'] as String? ?? 'Giao dịch từ hóa đơn';

        return TransactionProfile(
          title: title,
          time: time,
          amount: amount,
        );
      } else {
         throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể phân tích hóa đơn: $e');
    }
  }
}
