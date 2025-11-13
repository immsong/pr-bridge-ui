enum ErrorCode {
  invalidRequest,
  notFound,
  unauthorized,
  databaseError,
  githubApiError,
  jenkinsApiError,
  internalError,
  alreadyExists,
  validationError;

  static ErrorCode fromString(String code) {
    return switch (code.toUpperCase()) {
      'INVALID_REQUEST' => ErrorCode.invalidRequest,
      'NOT_FOUND' => ErrorCode.notFound,
      'UNAUTHORIZED' => ErrorCode.unauthorized,
      'DATABASE_ERROR' => ErrorCode.databaseError,
      'GITHUB_API_ERROR' => ErrorCode.githubApiError,
      'JENKINS_API_ERROR' => ErrorCode.jenkinsApiError,
      'INTERNAL_ERROR' => ErrorCode.internalError,
      'ALREADY_EXISTS' => ErrorCode.alreadyExists,
      'VALIDATION_ERROR' => ErrorCode.validationError,
      _ => ErrorCode.internalError,
    };
  }
}
