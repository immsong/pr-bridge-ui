import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_multiplatform_logger/flutter_multiplatform_logger.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

import 'package:pr_bridge_ui/models/websocket/websocket_message.dart';
import 'package:pr_bridge_ui/providers/websocket/message_route_provider.dart';
import 'package:pr_bridge_ui/providers/websocket/websocket_provider.dart';
import 'package:pr_bridge_ui/models/repository/repository.dart' as model;

class _TextStyles {
  // 헤더
  static const header = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const headerHeight = 30.0;

  // 아이템
  static const item = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const itemHeight = 30.0;
}

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebSocket 테스트'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Repository'),
              Tab(text: 'Jenkins'),
            ],
          ),
        ),
        body: TabBarView(children: [RepositoryTab(), JenkinsTab()]),
      ),
    );
  }
}

class RepositoryTab extends ConsumerStatefulWidget {
  const RepositoryTab({super.key});

  @override
  ConsumerState<RepositoryTab> createState() => _RepositoryTabState();
}

class _RepositoryTabState extends ConsumerState<RepositoryTab> {
  final _logger = Logger('RepositoryTab');

  final List<model.Repository> _repositoryList = [];

  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _repositoryNameController =
      TextEditingController();
  final TextEditingController _pollIntervalSecondsController =
      TextEditingController();
  final TextEditingController _isActiveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 연결 상태 확인
      final service = ref.read(wsServiceProvider);
      for (int i = 0; i < 30; i++) {
        if (service.currentState != null &&
            service.currentState == ws.Connected()) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (service.currentState != null &&
          service.currentState == ws.Connected()) {
        _refreshRepositoryList();
      } else {
        _logger.warning('WebSocket not connected yet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Repositories>>(repositoriesMessagesProvider, (
      previous,
      next,
    ) {
      _logger.info('repositoriesMessagesProvider: ${next.value}');
      setState(() {
        _repositoryList.clear();

        next.whenData((repos) {
          for (var repo in repos.repositories) {
            _repositoryList.add(repo);
          }
        });
      });
    });

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          ..._repositoryList.map((repository) => _buildItem(repository)),
          const SizedBox(height: 30),
          _buildBottom(),
        ],
      ),
    );
  }

  void _refreshRepositoryList() {
    try {
      final service = ref.read(wsServiceProvider);
      final message = ClientMessage(
        id: 'req-get-repositories',
        payload: ClientMessageType.getRepositories(),
      );
      _logger.info('message: ${message.toJsonString()}');
      service.send(message.toJsonString());
    } catch (e) {
      _logger.severe('전송 실패: $e');
    }
  }

  void _createRepository(String owner, String name) {
    try {
      final service = ref.read(wsServiceProvider);
      final message = ClientMessage(
        payload: ClientMessageType.addRepository(owner: owner, name: name),
      );
      service.send(message.toJsonString());
    } catch (e) {
      _logger.severe('Repository 생성 실패: $e');
    }
  }

  void _updateRepository(int repoId, bool isActive, int pollIntervalSeconds) {
    try {
      final service = ref.read(wsServiceProvider);
      final message = ClientMessage(
        payload: ClientMessageType.updateRepository(
          repoId: repoId,
          isActive: isActive,
          pollIntervalSeconds: pollIntervalSeconds,
        ),
      );
      service.send(message.toJsonString());
    } catch (e) {
      _logger.severe('Repository 업데이트 실패: $e');
    }
  }

  void _deleteRepository(int repoId) {
    try {
      final service = ref.read(wsServiceProvider);
      final message = ClientMessage(
        payload: ClientMessageType.deleteRepository(repoId),
      );
      service.send(message.toJsonString());
    } catch (e) {
      _logger.severe('Repository 삭제 실패: $e');
    }
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Repository', style: _TextStyles.header),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(labelText: 'Owner'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repositoryNameController,
              decoration: const InputDecoration(labelText: 'Repository Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _createRepository(
                _ownerController.text,
                _repositoryNameController.text,
              );
              await Future.delayed(const Duration(milliseconds: 500));
              _refreshRepositoryList();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(int repoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Repository', style: _TextStyles.header),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pollIntervalSecondsController,
              decoration: const InputDecoration(labelText: 'Poll Interval'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _isActiveController,
              decoration: const InputDecoration(labelText: 'Active'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateRepository(
                repoId,
                _isActiveController.text == 'true',
                int.parse(_pollIntervalSecondsController.text),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(double height) {
    return SizedBox(
      width: 9,
      height: height,
      child: Row(
        children: [
          const Spacer(),
          Container(
            width: 1,
            height: height * 0.7,
            color: Colors.grey.withAlpha(100),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: _TextStyles.header,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: _TextStyles.headerHeight,
      child: Row(
        children: [
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 1, child: _buildHeaderText('ID')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Owner')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Name')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Interval')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Active')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Created')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(flex: 2, child: _buildHeaderText('Updated')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(child: _buildHeaderText('Settings')),
          _buildSeparator(_TextStyles.headerHeight),
          Expanded(child: _buildHeaderText('Delete')),
          _buildSeparator(_TextStyles.headerHeight),
        ],
      ),
    );
  }

  Widget _buildItemText(String text) {
    return Tooltip(
      message: text,
      child: Text(
        text,
        style: _TextStyles.item,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildItem(model.Repository repository) {
    return SizedBox(
      height: _TextStyles.itemHeight,
      child: Row(
        children: [
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(child: _buildItemText(repository.id.toString())),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(flex: 2, child: _buildItemText(repository.owner)),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(flex: 2, child: _buildItemText(repository.name)),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 2,
            child: _buildItemText(repository.pollIntervalSeconds.toString()),
          ),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 2,
            child: _buildItemText(repository.isActive.toString()),
          ),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 2,
            child: _buildItemText(
              DateFormat('yyyy-MM-dd').format(repository.createdAt),
            ),
          ),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 2,
            child: _buildItemText(
              DateFormat('yyyy-MM-dd').format(repository.updatedAt),
            ),
          ),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  _showUpdateDialog(repository.id);
                  await Future.delayed(const Duration(milliseconds: 500));
                  _refreshRepositoryList();
                },
                icon: const Icon(
                  Icons.settings,
                  size: _TextStyles.itemHeight / 1.5,
                ),
              ),
            ),
          ),
          _buildSeparator(_TextStyles.itemHeight),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  _deleteRepository(repository.id);
                  await Future.delayed(const Duration(milliseconds: 500));
                  _refreshRepositoryList();
                },
                icon: const Icon(
                  Icons.delete,
                  size: _TextStyles.itemHeight / 1.5,
                ),
              ),
            ),
          ),
          _buildSeparator(_TextStyles.itemHeight),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      height: _TextStyles.itemHeight,
      child: Row(
        children: [
          const Spacer(flex: 2),
          const Spacer(),
          const Spacer(),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  _showCreateDialog();
                  await Future.delayed(const Duration(milliseconds: 500));
                  _refreshRepositoryList();
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  size: _TextStyles.itemHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JenkinsTab extends ConsumerStatefulWidget {
  const JenkinsTab({super.key});

  @override
  ConsumerState<JenkinsTab> createState() => _JenkinsTabState();
}

class _JenkinsTabState extends ConsumerState<JenkinsTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
