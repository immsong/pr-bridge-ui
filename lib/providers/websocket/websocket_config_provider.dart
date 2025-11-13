import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multiplatform_logger/flutter_multiplatform_logger.dart';

import 'package:pr_bridge_ui/models/websocket/websocket_config.dart';

part 'websocket_config_provider.g.dart';

@Riverpod(keepAlive: true)
class WebSocketConfigNotifier extends _$WebSocketConfigNotifier {
  final Logger _logger = Logger('WebSocketConfigNotifier');

  static const String _storageKey = 'websocket_config';
  late SharedPreferences _prefs;

  @override
  WebSocketConfig build() {
    _prefs = ref.read(sharedPreferencesProvider);
    return _loadConfig();
  }

  // 파일에서 설정 읽기
  WebSocketConfig _loadConfig() {
    final configJson = _prefs.getString(_storageKey);
    if (configJson != null) {
      try {
        final json = jsonDecode(configJson) as Map<String, dynamic>;
        return WebSocketConfig.fromJson(json);
      } catch (e) {
        _logger.severe('Failed to load config: $e');
      }
    }

    return WebSocketConfig();
  }

  // 설정 변경 및 저장
  Future<void> updateConfig(WebSocketConfig newConfig) async {
    state = newConfig;
    await _saveConfig();
  }

  // URL만 변경 및 저장
  Future<void> updateUrl(String url) async {
    state = WebSocketConfig(
      url: url,
      connectionTimeout: state.connectionTimeout,
    );
    await _saveConfig();
  }

  // 파일에 저장
  Future<void> _saveConfig() async {
    final configJson = jsonEncode(state.toJson());
    await _prefs.setString(_storageKey, configJson);
  }

  // 기본값 초기화 및 저장
  Future<void> reset() async {
    state = WebSocketConfig();
    await _saveConfig();
  }
}

// SharedPreferences Provider
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('SharedPreferences not initialized');
}
