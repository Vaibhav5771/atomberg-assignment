import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_text_styles.dart';
import '../widgets/app_alart_dialog.dart';
import '../widgets/app_alert_type.dart';
import '../widgets/credientials_section.dart';
import 'fan_list.dart';
import '../widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _refreshTokenController = TextEditingController();
  bool _saveCredentials = false;

  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _openWeb(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      showAppAlertDialog(
        context: context,
        type: AppAlertType.error,
        message: 'Could not open link',
      );
    }
  }

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

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FanListScreen()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        showAppAlertDialog(
          context: context,
          type: AppAlertType.error,
          message: 'Login failed',
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
        title: const Text(
          'Enter your credentials',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CredentialsSection(
                  apiKeyController: _apiKeyController,
                  refreshTokenController: _refreshTokenController,
                  saveCredentials: _saveCredentials,
                  onSaveCredentialsChanged: (value) {
                    setState(() {
                      _saveCredentials = value ?? false;
                    });
                  },
                  onOpenDeveloperPortal: () {
                    _openWeb('https://developer.atomberg-iot.com/');
                  },
                ),

                const SizedBox(height: 24),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: AppTextStyles.error,
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 32),
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