import 'dart:convert';

import 'package:flutter_multiplatform_logger/flutter_multiplatform_logger.dart';

import 'package:pr_bridge_ui/models/repository/repository.dart' as model;
import 'package:pr_bridge_ui/models/websocket/websocket_message_error.dart';

class ServerMessage {
  final String? id;
  final ServerMessageType payload;

  const ServerMessage({this.id, required this.payload});

  factory ServerMessage.fromJson(Map<String, dynamic> json) {
    return ServerMessage(
      id: json['id'] as String?,
      payload: ServerMessageType.fromJson(json),
    );
  }

  static ServerMessage fromJsonString(String jsonString) {
    return ServerMessage.fromJson(jsonDecode(jsonString));
  }
}

sealed class ServerMessageType {
  const ServerMessageType();

  factory ServerMessageType.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger('ServerMessageType');

    final type = json['type'] as String;
    final data = json['data'] as Map<String, dynamic>?;

    logger.info('type: $type');
    // logger.info('data: $data');

    switch (type) {
      // 응답
      case 'repositories':
        List<model.Repository> repositories = [];
        for (var e in data!['repositories'] as List) {
          repositories.add(model.Repository.fromJson(e));
          logger.info('repository: ${repositories[0]}');
        }
        return Repositories(repositories);
      case 'repository':
        return Repository(model.Repository.fromJson(data!['repository']));
      case 'success':
        return Success(message: data!['message'] as String, data: data['data']);
      // 에러
      case 'error':
        return Error(
          code: ErrorCode.fromString(data!['code'] as String),
          message: data['message'] as String,
          details: data['details'],
        );
      // Pong
      case 'pong':
        return const Pong();
      default:
        return UnknownMessage(type: type, data: data);
    }
  }
}

// 응답
class Repositories extends ServerMessageType {
  final List<model.Repository> repositories;
  const Repositories(this.repositories);
}

class Repository extends ServerMessageType {
  final model.Repository repository;
  const Repository(this.repository);
}

class Success extends ServerMessageType {
  final String message;
  final dynamic data;
  const Success({required this.message, this.data});
}

// 에러
class Error extends ServerMessageType {
  final ErrorCode code;
  final String message;
  final dynamic details;

  const Error({required this.code, required this.message, this.details});
}

// 기타
class Pong extends ServerMessageType {
  const Pong();
}

class UnknownMessage extends ServerMessageType {
  final String type;
  final Map<String, dynamic>? data;

  const UnknownMessage({required this.type, this.data});
}
