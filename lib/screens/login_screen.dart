// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'fan_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();        // Empty
  final _refreshTokenController = TextEditingController(); // Empty

  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final bool success = await _apiService.login(
      _apiKeyController.text.trim(),
      _refreshTokenController.text.trim(),
    );

    if (success) {
      final devices = await _apiService.getDevices();

      setState(() => _isLoading = false);

      // Allow navigation even in demo/fallback mode
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FanListScreen()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login failed. Please check your API Key and Refresh Token.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomberg Developer Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wind_power, size: 80, color: Colors.teal),
                const SizedBox(height: 32),
                const Text(
                  'Atomberg Smart Fan Control',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your developer credentials below',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // API Key Field
                TextFormField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'API Key (x-api-key)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                    hintText: 'Paste your API Key here',
                  ),
                  validator: (value) =>
                  value?.trim().isEmpty ?? true ? 'API Key is required' : null,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),

                // Refresh Token Field (larger for long JWT)
                TextFormField(
                  controller: _refreshTokenController,
                  decoration: const InputDecoration(
                    labelText: 'Refresh Token',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.token),
                    hintText: 'Paste your Refresh Token here',
                  ),
                  validator: (value) =>
                  value?.trim().isEmpty ?? true ? 'Refresh Token is required' : null,
                  maxLines: 4,
                  minLines: 2,
                ),
                const SizedBox(height: 24),

                // Error Message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Login & Load Fans',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Help text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'To get these credentials:\n'
                        '1. Open Atomberg Home app\n'
                        '2. Go to Profile → Developer Mode → Enable\n'
                        '3. Copy API Key and Refresh Token',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _refreshTokenController.dispose();
    super.dispose();
  }
}