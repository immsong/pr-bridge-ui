// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_route_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repositoriesMessages)
const repositoriesMessagesProvider = RepositoriesMessagesProvider._();

final class RepositoriesMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Repositories>,
          Repositories,
          Stream<Repositories>
        >
    with $FutureModifier<Repositories>, $StreamProvider<Repositories> {
  const RepositoriesMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoriesMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoriesMessagesHash();

  @$internal
  @override
  $StreamProviderElement<Repositories> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Repositories> create(Ref ref) {
    return repositoriesMessages(ref);
  }
}

String _$repositoriesMessagesHash() =>
    r'84caa4ba89464c9e82b629223ad3f32ca80d28db';

@ProviderFor(repositoryMessages)
const repositoryMessagesProvider = RepositoryMessagesProvider._();

final class RepositoryMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Repository>,
          Repository,
          Stream<Repository>
        >
    with $FutureModifier<Repository>, $StreamProvider<Repository> {
  const RepositoryMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryMessagesHash();

  @$internal
  @override
  $StreamProviderElement<Repository> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Repository> create(Ref ref) {
    return repositoryMessages(ref);
  }
}

String _$repositoryMessagesHash() =>
    r'd2fb1f91e3d0234e73faa4a09382096ec71f2f11';

@ProviderFor(successMessages)
const successMessagesProvider = SuccessMessagesProvider._();

final class SuccessMessagesProvider
    extends $FunctionalProvider<AsyncValue<Success>, Success, Stream<Success>>
    with $FutureModifier<Success>, $StreamProvider<Success> {
  const SuccessMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'successMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$successMessagesHash();

  @$internal
  @override
  $StreamProviderElement<Success> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Success> create(Ref ref) {
    return successMessages(ref);
  }
}

String _$successMessagesHash() => r'e2cdfb06130c086949615f3df1e17a9e37455cdd';

@ProviderFor(errorMessages)
const errorMessagesProvider = ErrorMessagesProvider._();

final class ErrorMessagesProvider
    extends $FunctionalProvider<AsyncValue<Error>, Error, Stream<Error>>
    with $FutureModifier<Error>, $StreamProvider<Error> {
  const ErrorMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorMessagesHash();

  @$internal
  @override
  $StreamProviderElement<Error> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Error> create(Ref ref) {
    return errorMessages(ref);
  }
}

String _$errorMessagesHash() => r'ae7fc893f5bb9c43bae4b35a106d461d923068f5';
