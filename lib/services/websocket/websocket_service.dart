import 'dart:async';
import 'package:flutter_multiplatform_logger/flutter_multiplatform_logger.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:pr_bridge_ui/models/websocket/websocket_config.dart';

class WebSocketService {
  final _logger = Logger('WebSocketService');

  WebSocket? _socket;
  WebSocketConfig? _config;

  // 연결 상태 스트림
  // WebSocket 연결 상태가 변할때마다 이 스트림에 이벤트가 발생
  Stream<ConnectionState> get connectionStream =>
      _socket?.connection ?? const Stream.empty();

  // 메시지 스트림
  // WebSocket 메시지가 수신될 때마다 이 스트리에 이벤트가 발생
  Stream<dynamic> get messageStream =>
      _socket?.messages ?? const Stream.empty();

  // 현재 연결 상태
  // WebSocket 연결 상태를 반환
  ConnectionState? get currentState => _socket?.connection.state;

  // 연결
  Future<void> connect(WebSocketConfig config) async {
    _config = config;

    _logger.info('Connecting to ${config.url}');

    _socket = WebSocket(
      Uri.parse(_config!.url),
      timeout: _config!.connectionTimeout,
    );
  }

  // 메시지 전송
  void send(String message) {
    _socket?.send(message);
    _logger.fine('Sent: $message');
  }

  // 연결 해제
  void disconnect() {
    _logger.info('Disconnecting');
    _socket?.close(1000, 'Normal closure');
    _socket = null;
  }

  // 리소스 정리
  void dispose() {
    disconnect();
  }
}
