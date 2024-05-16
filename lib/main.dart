import 'package:flutter/material.dart';
import 'package:method_channel_flutter/features/battery_device/presentation/views/storage_device_page.dart';
import 'package:method_channel_flutter/features/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Method Channel Flutter',
      routes: {
        '/battery-device': (_) => const BatteryDevicePage(),
      },
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
