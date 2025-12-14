// lib/screens/fan_list.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'fan_control.dart';

class FanListScreen extends StatefulWidget {
  const FanListScreen({super.key});

  @override
  State<FanListScreen> createState() => _FanListScreenState();
}

class _FanListScreenState extends State<FanListScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _fans = [];
  Map<String, Map<String, dynamic>> _states = {}; // device_id → state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    setState(() => _isLoading = true);

    // Load devices and states in parallel
    final devicesFuture = _apiService.getDevices();
    final statesFuture = _apiService.getDeviceStates();

    final devices = await devicesFuture;
    final states = await statesFuture;

    setState(() {
      _fans = devices;
      _states = states;
      _isLoading = false;
    });
  }

  Widget _buildFanCard(Map<String, dynamic> fan) {
    final String deviceId = fan['device_id'];
    final bool isDemo = deviceId.contains('DEMO');
    final state = _states[deviceId];

    final bool isOn = state?['power'] ?? false;
    final int speed = state?['speed'] ?? 0;
    final bool isOnline = state?['is_online'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FanControlScreen(fan: fan, currentState: state),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fan['name'] ?? 'Unnamed Fan',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isDemo)
                    const Chip(
                      label: Text('DEMO', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.orange,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Room: ${fan['room'] ?? 'Not set'}'),
              Text('Model: ${fan['model'] ?? 'Unknown'}'),
              if (fan['color'] != null) Text('Color: ${fan['color']}'),
              const SizedBox(height: 8),
              Text(
                'Device ID: $deviceId',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Real Status Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isOn ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isOn ? Colors.green.shade300 : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isOn ? Icons.power_settings_new : Icons.power_off,
                          color: isOn ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isOn ? 'ON' : 'OFF',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isOn ? Colors.green.shade800 : Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          color: isOnline ? Colors.blue : Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOnline ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (isOn) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Speed: $speed ${speed >= 6 ? '(Boost)' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'Tap card to control →',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Atomberg Fans'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEverything,
            tooltip: 'Refresh devices & status',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('API Status'),
                  content: Text(_apiService.getApiStatus()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fans.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No fans found', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              _apiService.getApiStatus().contains('fallback')
                  ? 'Currently in demo mode'
                  : 'Make sure fans are added in Atomberg app',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadEverything,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          itemCount: _fans.length,
          itemBuilder: (context, index) => _buildFanCard(_fans[index]),
        ),
      ),
    );
  }
}