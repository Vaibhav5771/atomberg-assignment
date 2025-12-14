import 'package:flutter/material.dart';
import '../screens/fan_control.dart';

class FanCard extends StatelessWidget {
  final Map<String, dynamic> fan;
  final Map<String, dynamic> state;

  const FanCard({
    super.key,
    required this.fan,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final String deviceId = fan['device_id'] ?? 'UNKNOWN';
    final bool isDemo = deviceId.contains('DEMO');

    final bool isOn = state['power'] ?? false;
    final int speed = state['speed'] ?? 0;
    final bool isOnline = state['is_online'] ?? false;

    final bool isBoost = speed >= 6;
    final bool isSleep = state['sleep_mode'] == true;
    final bool hasTimer = (state['timer_hours'] ?? 0) > 0;

    String? modeLabel;
    Color? modeColor;

    if (isBoost) {
      modeLabel = 'BOOST';
      modeColor = Colors.redAccent;
    } else if (isSleep) {
      modeLabel = 'SLEEP';
      modeColor = Colors.purpleAccent;
    } else if (hasTimer) {
      modeLabel = 'TIMER';
      modeColor = Colors.orangeAccent;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: Colors.white),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FanControlScreen(
                fan: fan,
                currentState: state,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fan['name'] ?? 'Unnamed Fan',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (isDemo)
                        const Chip(
                          label: Text('DEMO', style: TextStyle(fontSize: 10)),
                          backgroundColor: Colors.orange,
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSans',
                        fontSize: 12,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Room: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: fan['room'] ?? 'Not set',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSans',
                        fontSize: 12,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Model: ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: fan['model'] ?? 'Unknown',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  if (fan['color'] != null)
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSans',
                          fontSize: 12,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Color: ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: fan['color'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),


                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.white24,
                    thickness: 0.6,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        isOn ? Icons.power_settings_new : Icons.power_off,
                        size: 20,
                        color: isOn ? Colors.lightGreenAccent : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isOn ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isOn
                              ? Colors.lightGreenAccent
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),

                  if (isOn) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Speed: $speed',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (modeLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: modeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              modeLabel!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF200),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'Tap to control',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  size: 18,
                  color: isOnline
                      ? const Color(0xFFFFF200)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
