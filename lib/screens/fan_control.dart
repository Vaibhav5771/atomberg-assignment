import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_text_styles.dart';
import '../widgets/fan_info_card.dart';
import '../widgets/modes_section.dart';
import '../widgets/power_controls.dart';
import '../widgets/speed_control.dart';
import '../widgets/timer_control.dart';

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
    _state = widget.currentState ??
        {
          'power': false,
          'speed': 0,
          'is_online': false,
          'timer_hours': 0,
          'sleep_mode': false,
          'led': false,
        };
  }

  // -------- TIMER LABEL --------
  String _timerLabel(int value) {
    switch (value) {
      case 1:
        return '1 Hour';
      case 2:
        return '2 Hours';
      case 3:
        return '3 Hours';
      case 4:
        return '6 Hours';
      default:
        return 'OFF';
    }
  }

  // -------- REFRESH --------
  Future<void> _refreshState() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final states = await _apiService.getDeviceStates();
    final newState = states[widget.fan['device_id']];

    if (!mounted) return;

    setState(() {
      if (newState != null) _state = newState;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newState != null ? 'Status refreshed' : 'No update available'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // -------- SEND COMMAND --------
  Future<void> _sendCommand(Map<String, dynamic> commands) async {
    final success =
    await _apiService.controlDevice(widget.fan['device_id'], commands);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device is offline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Command sent'),
        backgroundColor: Colors.green,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _refreshState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isOn = _state['power'] ?? false;
    final int currentSpeed = _state['speed'] ?? 0;
    final bool isOnline = _state['is_online'] ?? false;
    final int timerHours = _state['timer_hours'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        title: Text(
          widget.fan['name'] ?? 'Fan Control',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 0.5, // small border
          ),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.refresh,color: Colors.white,),
            onPressed: _isLoading ? null : _refreshState,
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
              // -------- FAN INFO CARD --------
              FanInfoCard(
                fan: widget.fan,
                isOnline: isOnline,
              ),

              const SizedBox(height: 40),

              // -------- POWER --------
              PowerControls(
                isOn: isOn,
                onOn: () => _sendCommand({"power": "on"}),
                onOff: () => _sendCommand({"power": "off"}),
              ),

              const SizedBox(height: 40),

              // -------- SPEED --------
              SpeedControl(
                isOn: isOn,
                speed: currentSpeed,
                onSpeedChanged: (speed) {
                  if (speed == 0) {
                    _sendCommand({"power": "off"});
                  } else {
                    _sendCommand({"power": "on", "fan_speed": speed});
                  }
                },
              ),

              const SizedBox(height: 40),

              // -------- MODES --------
              ModesSection(
                onBoostOn: () => _sendCommand({"fan_speed": 6}),
                onBoostOff: () => _sendCommand({"fan_speed": 3}),
              ),

              const SizedBox(height: 40),

              // -------- TIMER --------
              TimerControl(
                timer: timerHours,
                labelBuilder: _timerLabel,
                onTimerChanged: (v) => _sendCommand({"timer": v}),
              ),

              const SizedBox(height: 50),
            ],

          ),
        ),
      ),
    );
  }
}
