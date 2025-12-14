import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_text_styles.dart';
import '../widgets/app_alart_dialog.dart';
import '../widgets/app_alert_type.dart';
import '../widgets/fan_card.dart';
import '../widgets/primary_button.dart';

class FanListScreen extends StatefulWidget {
  const FanListScreen({super.key});

  @override
  State<FanListScreen> createState() => _FanListScreenState();
}

class _FanListScreenState extends State<FanListScreen> {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _fans = [];
  Map<String, Map<String, dynamic>> _states = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    setState(() => _isLoading = true);

    try {
      final devicesFuture = _apiService.getDevices();
      final statesFuture = _apiService.getDeviceStates();

      final devices = await devicesFuture;
      final states = await statesFuture;

      setState(() {
        _fans = devices;
        _states = states;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
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
          'My Devices List',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh devices',
            onPressed: _loadEverything,
          ),
        ],
      ),


      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Expanded(
            child: _fans.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadEverything,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 16,
                ),
                itemCount: _fans.length,
                itemBuilder: (context, index) {
                  final fan = _fans[index];
                  final deviceId = fan['device_id'];
                  final state = _states[deviceId] ?? {};

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FanCard(
                      fan: fan,
                      state: state,
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: PrimaryButton(
              text: 'Add New',
              isLoading: false,
              onPressed: () {
                showAppAlertDialog(
                  context: context,
                  type: AppAlertType.comingSoon,
                  message: 'Coming soon',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.air,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No fans found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'IBMPlexSans',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your fans are added in the Atomberg app\nand you are logged in',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Refresh',
            isLoading: false,
            onPressed: _loadEverything,
          ),
        ],
      ),
    );
  }
}
