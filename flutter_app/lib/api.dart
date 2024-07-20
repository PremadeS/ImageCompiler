import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:5000';

  Future<String> uploadImage(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ),
    );
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        return response.stream.bytesToString();
      } else {
        return 'Image upload failed';
      }
    } catch (e) {
      return "Server Error: $e";
    }
  }

  Future<String> compileAndRunCode(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/compile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load text');
    }
  }
}
