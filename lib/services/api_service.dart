import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://api.developer.atomberg-iot.com/v1';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> login(String apiKey, String refreshToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_access_token'),
        headers: {
          'x-api-key': apiKey,
          'Authorization': 'Bearer $refreshToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Success' && data['message']['access_token'] != null) {
          final accessToken = data['message']['access_token'];

          await storage.write(key: 'access_token', value: accessToken);
          await storage.write(key: 'api_key', value: apiKey);
          await storage.write(key: 'refresh_token', value: refreshToken);

          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getDevices() async {
    final accessToken = await storage.read(key: 'access_token');
    final apiKey = await storage.read(key: 'api_key');

    if (accessToken == null || apiKey == null) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_list_of_devices'),
        headers: {
          'x-api-key': apiKey,
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseDevices(data);
      }
    } catch (e) {
      // Silent fallback on error/network issues
    }

    return [];
  }

  List<Map<String, dynamic>> _parseDevices(dynamic data) {
    if (data['status'] != 'Success' || data['message']?['devices_list'] == null) {
      return [];
    }

    final List devicesList = data['message']['devices_list'];

    return devicesList.map<Map<String, dynamic>>((device) {
      final metadata = device['metadata'] ?? {};
      return {
        'device_id': device['device_id'],
        'name': device['name'] ?? 'Unknown Fan',
        'room': device['room'] ?? 'Unknown',
        'model': device['model'] ?? 'Unknown',
        'color': device['color'],
        'series': device['series'],
        'ssid': metadata['ssid'],
        'type': 'FAN',
        'capabilities': ['power', 'speed', 'timer', 'boost_mode'],
      };
    }).toList();
  }

  Future<bool> controlDevice(String deviceId, Map<String, dynamic> commands) async {
    final accessToken = await storage.read(key: 'access_token');
    final apiKey = await storage.read(key: 'api_key');

    if (accessToken == null || apiKey == null) {
      return false;
    }

    final Map<String, dynamic> apiCommand = {};

    if (commands.containsKey('power')) {
      apiCommand['power'] = commands['power'] == 'on';
    }

    if (commands.containsKey('fan_speed')) {
      apiCommand['speed'] = commands['fan_speed'];
    }

    if (commands.containsKey('timer')) {
      apiCommand['timer'] = commands['timer'];
    }

    if (commands.containsKey('boost_mode')) {
      apiCommand['boost_mode'] = commands['boost_mode'] == 'on';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send_command'),
        headers: {
          'x-api-key': apiKey,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "device_id": deviceId,
          "command": apiCommand,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['status'] == 'Success';
      }
    } catch (e) {
      // Silent on network/error
    }

    return false;
  }

  Future<bool> turnOn(String deviceId) => controlDevice(deviceId, {'power': 'on'});

  Future<bool> turnOff(String deviceId) => controlDevice(deviceId, {'power': 'off'});

  Future<bool> setSpeed(String deviceId, int speed) =>
      controlDevice(deviceId, {'fan_speed': speed.clamp(1, 5)});

  Future<bool> setTimer(String deviceId, int hours) =>
      controlDevice(deviceId, {'timer': hours});

  Future<bool> toggleBoost(String deviceId, bool enable) =>
      controlDevice(deviceId, {'boost_mode': enable ? 'on' : 'off'});

  Future<Map<String, Map<String, dynamic>>> getDeviceStates() async {
    final accessToken = await storage.read(key: 'access_token');
    final apiKey = await storage.read(key: 'api_key');

    if (accessToken == null || apiKey == null) {
      return {};
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_device_state?device_id=all'),
        headers: {
          'x-api-key': apiKey,
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Success' && data['message']['device_state'] is List) {
          final List states = data['message']['device_state'];
          final Map<String, Map<String, dynamic>> stateMap = {};

          for (var state in states) {
            stateMap[state['device_id']] = {
              'power': state['power'] as bool? ?? false,
              'speed': state['last_recorded_speed'] as int? ?? 0,
              'is_online': state['is_online'] as bool? ?? false,
              'timer_hours': state['timer_hours'] as int? ?? 0,
              'sleep_mode': state['sleep_mode'] as bool? ?? false,
              'led': state['led'] as bool? ?? false,
              'timestamp': state['ts_epoch_seconds'] != null
                  ? DateTime.fromMillisecondsSinceEpoch((state['ts_epoch_seconds'] as int) * 1000)
                  : null,
            };
          }
          return stateMap;
        }
      }
    } catch (e) {
      // Silent on error
    }

    return {};
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
}