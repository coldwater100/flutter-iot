import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For platform-specific handling

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter + FastAPI',
      home: HelloScreen(),
    );
  }
}

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});
  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  String _message = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchHelloMessage();
  }

  // Return base URL depending on the platform
  String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Host machine from Android emulator
    } else {
      return 'http://localhost:8000'; // macOS, iOS, Windows, etc.
    }
  }

  // Fetch the message from the FastAPI backend
  Future<void> _fetchHelloMessage() async {
    try {
      final uri = Uri.parse('${getBaseUrl()}/hello');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _message = data['message'] ?? 'No message';
        });
      } else {
        setState(() {
          _message = 'Failed with status ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Center(child: Text(_message, style: const TextStyle(fontSize: 20))),
    );
  }
}
