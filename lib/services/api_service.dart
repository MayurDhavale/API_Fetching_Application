
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  /// Fetches posts from the API
  static Future<List<dynamic>> fetchPosts() async {
    final url = Uri.parse(_apiUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load posts. Please check your internet connection.');
    }
  }
}
