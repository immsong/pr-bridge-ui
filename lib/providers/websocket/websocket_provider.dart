import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pr_bridge_ui/services/websocket/websocket_service.dart';
import 'package:pr_bridge_ui/providers/websocket/websocket_config_provider.dart';

part 'websocket_provider.g.dart';

@Riverpod(keepAlive: true)
WebSocketService wsService(Ref ref) {
  final service = WebSocketService();
  
  // Config 변경 감지하여 재연결
  ref.listen(
    webSocketConfigProvider,
    (previous, next) {
      if (previous?.url != next.url) {
        // URL 변경되면 재연결
        service.disconnect();
        service.connect(next);
      }
    },
  );
  
  // 초기 연결
  final config = ref.read(webSocketConfigProvider);
  service.connect(config);
  
  // Dispose 시 정리
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
}