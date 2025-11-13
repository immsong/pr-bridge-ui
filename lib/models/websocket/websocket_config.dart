class WebSocketConfig {
  final String url;
  final Duration connectionTimeout;

  const WebSocketConfig({
    this.url = 'ws://localhost:8080',
    this.connectionTimeout = const Duration(seconds: 10),
  });

  Map<String, dynamic> toJson() {
    return {'url': url, 'connectionTimeout': connectionTimeout.inSeconds};
  }

  factory WebSocketConfig.fromJson(Map<String, dynamic> json) {
    return WebSocketConfig(
      url: json['url'] as String? ?? 'ws://localhost:8080',
      connectionTimeout: Duration(
        seconds: json['connectionTimeout'] as int? ?? 10,
      ),
    );
  }
}
