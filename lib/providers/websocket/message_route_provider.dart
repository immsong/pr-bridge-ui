import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pr_bridge_ui/models/websocket/websocket_message.dart';
import 'package:pr_bridge_ui/providers/websocket/websocket_provider.dart';

part 'message_route_provider.g.dart';

Stream<T> _messagesOfType<T extends ServerMessageType>(Ref ref) {
  final service = ref.watch(wsServiceProvider);
  return service.messageStream
      .map((raw) => ServerMessage.fromJsonString(raw.toString()))
      .where((msg) => msg.payload is T)
      .map((msg) => msg.payload as T);
}

@riverpod
Stream<Repositories> repositoriesMessages(Ref ref) {
  return _messagesOfType<Repositories>(ref);
}

@riverpod
Stream<Repository> repositoryMessages(Ref ref) {
  return _messagesOfType<Repository>(ref);
}

@riverpod
Stream<Success> successMessages(Ref ref) {
  return _messagesOfType<Success>(ref);
}

@riverpod
Stream<Error> errorMessages(Ref ref) {
  return _messagesOfType<Error>(ref);
}
