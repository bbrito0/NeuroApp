class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class AuthException extends ApiException {
  AuthException(super.message, {super.statusCode});
}

class UserNotFoundException extends ApiException {
  UserNotFoundException() : super('User not found in backend', statusCode: 404);
}

class UserConflictException extends ApiException {
  UserConflictException(String message) : super(message, statusCode: 409);
} 