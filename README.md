# PR Bridge UI

GitHub Pull Request 감지 및 Jenkins 트리거 관리를 위한 웹 기반 관리 인터페이스입니다.

## 개요

PR Bridge UI는 PR Bridge 서버와 WebSocket으로 실시간 통신하며, GitHub PR 폴링 설정과 Jenkins 빌드 트리거를 관리할 수 있는 Flutter 기반 웹 애플리케이션입니다.

## 주요 기능

### 설정 관리
- GitHub 저장소 등록 및 관리
- Jenkins 서버 연동 설정
- PR 폴링 주기 실시간 조정

### 모니터링
- PR 폴링 상태 실시간 확인
- 빌드 트리거 이력 조회
- 서버 연결 상태 표시

### 실시간 통신
- WebSocket 기반 양방향 통신
- 설정 변경 즉시 반영
- 서버 이벤트 실시간 수신