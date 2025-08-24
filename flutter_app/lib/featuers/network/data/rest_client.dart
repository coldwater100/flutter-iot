import 'dart:convert';
import 'package:http/http.dart' as http;

class RestClient {
  final String baseUrl;

  RestClient({required this.baseUrl});

  Future<Map<String, dynamic>> getHello() async {
    final response = await http.get(Uri.parse('$baseUrl/hello'));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> sendData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> notify(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }
}
