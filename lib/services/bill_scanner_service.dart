import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/transactionproflie.dart';

class BillScannerService {
  static Future<TransactionProfile?> scanBill(File imageFile) async {
    final geminiKey = dotenv.env['GEMINI_API_KEY'];
    final endpoint = dotenv.env['AI_API_ENDPOINT'];
    
    if ((geminiKey == null || geminiKey.isEmpty) && (endpoint == null || endpoint.isEmpty)) {
      throw Exception('Chưa cấu hình GEMINI_API_KEY hoặc AI_API_ENDPOINT trong file .env.');
    }

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      late http.Response response;
      final prompt = 'Analyze this receipt and return a JSON object with: amount (number), time (ISO8601 format), title (string). Only output raw JSON.';

      if (geminiKey != null && geminiKey.isNotEmpty) {
        // Gọi thẳng Gemini REST API
        final geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey';
        response = await http.post(
          Uri.parse(geminiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                  {
                    'inline_data': {
                      'mime_type': 'image/jpeg',
                      'data': base64Image
                    }
                  }
                ]
              }
            ]
          }),
        ).timeout(const Duration(seconds: 45));
      } else {
        // Universal HTTP POST
        response = await http.post(
          Uri.parse(endpoint!),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'image': base64Image,
            'prompt': prompt,
          }),
        ).timeout(const Duration(seconds: 45));
      }

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
