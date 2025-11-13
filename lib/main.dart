import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multiplatform_logger/flutter_multiplatform_logger.dart';

import 'package:pr_bridge_ui/screens/test_screen.dart';
import 'package:pr_bridge_ui/providers/websocket/websocket_config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 로거 초기화
  await FlutterMultiplatformLogger.init();
  final logger = Logger('Main');
  logger.info('Starting application');

  // SharedPreferences 초기화
  final sharedPrefs = await SharedPreferences.getInstance();
  logger.info('SharedPreferences initialized');

  runApp(
    ProviderScope(
      overrides: [
        // SharedPreferences Provider 오버라이드
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: MaterialApp(home: const TestScreen()),
    ),
  );
}
