// lib/screens/fan_control.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FanControlScreen extends StatefulWidget {
  final Map<String, dynamic> fan;
  final Map<String, dynamic>? currentState;

  const FanControlScreen({
    super.key,
    required this.fan,
    this.currentState,
  });

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  final ApiService _apiService = ApiService();

  late Map<String, dynamic> _state;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _state = widget.currentState ?? {
      'power': false,
      'speed': 0,
      'is_online': false,
      'timer_hours': 0,
      'sleep_mode': false,
      'led': false,
    };
  }

  Future<void> _refreshState() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final states = await _apiService.getDeviceStates();
    final newState = states[widget.fan['device_id']];

    if (mounted) {
      setState(() {
        if (newState != null) _state = newState;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newState != null ? 'Status refreshed' : 'No update available'),
          duration: const Duration(seconds: 2),
          backgroundColor: newState != null ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  Future<void> _sendCommand(Map<String, dynamic> commands) async {
    final success = await _apiService.controlDevice(widget.fan['device_id'], commands);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Command sent!'), backgroundColor: Colors.green),
      );

      // Optimistic UI update
      setState(() {
        if (commands.containsKey('power')) {
          _state['power'] = commands['power'] == 'on';
        }
        if (commands.containsKey('fan_speed')) {
          _state['speed'] = commands['fan_speed'];
          _state['power'] = true;
        }
        if (commands.containsKey('boost_mode')) {
          _state['speed'] = commands['boost_mode'] == 'on' ? 6 : _state['speed'].clamp(1, 5);
          _state['power'] = true;
        }
        if (commands.containsKey('timer')) {
          _state['timer_hours'] = commands['timer'] > 0 ? (commands['timer'] ~/ 60) : 0;
        }
      });

      // Auto-refresh state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _refreshState();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Command failed'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOn = _state['power'] ?? false;
    final int currentSpeed = _state['speed'] ?? 0;
    final bool isOnline = _state['is_online'] ?? false;
    final int timerHours = _state['timer_hours'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fan['name'] ?? 'Fan Control'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshState,
            tooltip: 'Refresh status',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshState,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fan Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room: ${widget.fan['room'] ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
                      Text('Model: ${widget.fan['model'] ?? 'Unknown'}', style: const TextStyle(fontSize: 16)),
                      if (widget.fan['color'] != null)
                        Text('Color: ${widget.fan['color']}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      Text('Device ID: ${widget.fan['device_id']}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Live Status Card
              Card(
                color: isOnline ? Colors.blue.shade50 : Colors.grey.shade100,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(isOnline ? Icons.wifi : Icons.wifi_off,
                              color: isOnline ? Colors.blue : Colors.grey[600]),
                          const SizedBox(width: 10),
                          Text(
                            isOnline ? 'Connected' : 'Last Known State',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        isOn ? 'Fan is ON' : 'Fan is OFF',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isOn ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Speed: $currentSpeed${currentSpeed >= 6 ? ' (Boost Mode)' : ''}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      if (timerHours > 0)
                        Text('Timer: $timerHours hour${timerHours > 1 ? 's' : ''} remaining',
                            style: const TextStyle(fontSize: 16, color: Colors.orange)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Power Buttons
              const Text('Power', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: isOn ? null : () => _sendCommand({"power": "on"}),
                    icon: const Icon(Icons.power_settings_new, size: 20),
                    label: const Text('TURN ON', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: !isOn ? null : () => _sendCommand({"power": "off"}),
                    icon: const Icon(Icons.power_off, size: 20),
                    label: const Text('TURN OFF', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Speed Control
              const Text('Speed Control', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Slider(
                min: 0,
                max: 5,
                divisions: 5,
                value: isOn ? currentSpeed.clamp(0, 5).toDouble() : 0,
                activeColor: Colors.teal,
                inactiveColor: Colors.grey.shade300,
                label: isOn ? currentSpeed.clamp(0, 5).toString() : 'OFF',
                onChanged: isOn
                    ? (value) {
                  final int speed = value.round();
                  if (speed == 0) {
                    _sendCommand({"power": "off"});
                  } else {
                    _sendCommand({"power": "on", "fan_speed": speed});
                  }
                }
                    : null,
              ),
              Center(
                child: Text(
                  currentSpeed >= 6
                      ? 'Boost Mode Active (Speed 6)'
                      : 'Current Speed: ${isOn ? currentSpeed : 0}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 40),

              // Extra Controls
              const Text('Extra Controls', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _sendCommand({"boost_mode": "on"}),
                    icon: const Icon(Icons.speed, color: Colors.orange),
                    label: const Text('Boost ON'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _sendCommand({"boost_mode": "off"}),
                    icon: const Icon(Icons.speed_outlined),
                    label: const Text('Boost OFF'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _sendCommand({"timer": 120}),
                    icon: const Icon(Icons.timer),
                    label: const Text('2-Hour Timer'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _sendCommand({"timer": 0}),
                    icon: const Icon(Icons.timer_off),
                    label: const Text('Clear Timer'),
                  ),
                ],
              ),

              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Pull down or tap refresh to update status\nCommands are sent instantly via cloud',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}