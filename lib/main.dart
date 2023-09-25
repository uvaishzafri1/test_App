import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mac_address/mac_address.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';
  String _connectionState = 'Unknown connection state';
  String _macAddress = "Unknown mac Address";

  // Get battery level.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _getBatteryLevel,
                  child: const Text('Fetch Battery Percentage'),
                ),
                Text(
                  _batteryLevel,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: _getConnectionState,
                  child: const Text('Fetch Wi-Fi State'),
                ),
                Text(
                  _connectionState,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: _getMacAddress,
                  child: const Text('Fetch and Show MAC Address'),
                ),
                Text(
                  _macAddress,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getConnectionState() async {
    String connectionState = "";
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connectionState = "I am connected to a mobile network.";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connectionState = "I am connected to a wifi network.";
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      connectionState = "I am connected to a ethernet network.";
    } else if (connectivityResult == ConnectivityResult.vpn) {
      connectionState = "I am connected to a vpn network.";
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      connectionState = "I am connected to a bluetooth.";
    } else if (connectivityResult == ConnectivityResult.other) {
      connectionState =
          "I am connected to a network which is not in the above mentioned networks.";
    } else if (connectivityResult == ConnectivityResult.none) {
      connectionState = "I am not connected to any network.";
    }

    setState(() {
      _connectionState = connectionState;
    });
  }

  Future<void> _getMacAddress() async {
    String macAddress = await GetMac.macAddress;

    setState(() {
      _macAddress = macAddress;
    });
  }
}
