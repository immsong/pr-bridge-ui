// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WebSocketConfigNotifier)
const webSocketConfigProvider = WebSocketConfigNotifierProvider._();

final class WebSocketConfigNotifierProvider
    extends $NotifierProvider<WebSocketConfigNotifier, WebSocketConfig> {
  const WebSocketConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'webSocketConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$webSocketConfigNotifierHash();

  @$internal
  @override
  WebSocketConfigNotifier create() => WebSocketConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WebSocketConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WebSocketConfig>(value),
    );
  }
}

String _$webSocketConfigNotifierHash() =>
    r'27895e6fc9a8d9fd9d1529d3899eb50f59b008f9';

abstract class _$WebSocketConfigNotifier extends $Notifier<WebSocketConfig> {
  WebSocketConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WebSocketConfig, WebSocketConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WebSocketConfig, WebSocketConfig>,
              WebSocketConfig,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'1da48e3cc521b0a322a996edafc5b8267ac91549';
