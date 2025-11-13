import 'dart:convert';

class ClientMessage {
  final String? id;
  final ClientMessageType payload;

  const ClientMessage({this.id, required this.payload});

  Map<String, dynamic> toJson() {
    final json = payload.toJson();
    if (id != null) {
      json['id'] = id;
    }
    return json;
  }

  String toJsonString() => jsonEncode(toJson());
}

sealed class ClientMessageType {
  const ClientMessageType();

  Map<String, dynamic> toJson();

  // 저장소 관리
  factory ClientMessageType.addRepository({
    required String owner,
    required String name,
    int? pollIntervalSeconds,
  }) = AddRepository;

  factory ClientMessageType.updateRepository({
    required int repoId,
    bool? isActive,
    int? pollIntervalSeconds,
  }) = UpdateRepository;

  factory ClientMessageType.deleteRepository(int repoId) = DeleteRepository;

  factory ClientMessageType.getRepositories() = GetRepositories;

  factory ClientMessageType.getRepository(int repoId) = GetRepository;
}

// 저장소 관리
class AddRepository extends ClientMessageType {
  final String owner;
  final String name;
  final int? pollIntervalSeconds;

  const AddRepository({
    required this.owner,
    required this.name,
    this.pollIntervalSeconds,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'add_repository',
    'data': {
      'owner': owner,
      'name': name,
      if (pollIntervalSeconds != null)
        'poll_interval_seconds': pollIntervalSeconds,
    },
  };
}

class UpdateRepository extends ClientMessageType {
  final int repoId;
  final bool? isActive;
  final int? pollIntervalSeconds;

  const UpdateRepository({
    required this.repoId,
    this.isActive,
    this.pollIntervalSeconds,
  });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'update_repository',
    'data': {
      'repo_id': repoId,
      if (isActive != null) 'is_active': isActive,
      if (pollIntervalSeconds != null)
        'poll_interval_seconds': pollIntervalSeconds,
    },
  };
}

class DeleteRepository extends ClientMessageType {
  final int repoId;

  const DeleteRepository(this.repoId);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'delete_repository',
    'data': {'repo_id': repoId},
  };
}

// 조회 메시지들
class GetRepositories extends ClientMessageType {
  const GetRepositories();

  @override
  Map<String, dynamic> toJson() => {'type': 'get_repositories'};
}

class GetRepository extends ClientMessageType {
  final int repoId;

  const GetRepository(this.repoId);

  @override
  Map<String, dynamic> toJson() => {
    'type': 'get_repository',
    'data': {'repo_id': repoId},
  };
}