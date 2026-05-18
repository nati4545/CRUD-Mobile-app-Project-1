abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  NetworkFailure({
    String message = 'Network error. Please check your connection.',
    String? code,
  }) : super(message: message, code: code);
}

class ServerFailure extends Failure {
  ServerFailure({
    String message = 'Server error. Please try again later.',
    String? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  ValidationFailure({
    String message = 'Validation error',
    String? code,
  }) : super(message: message, code: code);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({
    String message = 'Resource not found',
    String? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  CacheFailure({
    String message = 'Cache error',
    String? code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  UnknownFailure({
    String message = 'An unknown error occurred',
    String? code,
  }) : super(message: message, code: code);
}
