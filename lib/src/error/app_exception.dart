// An abstract class `AppException` which implements the `Exception` interface.
// It contains the message, prefix and url associated with the exception.

abstract class AppException implements Exception {
  final String? message, prefix, url;

  // Constructor which takes the `message`, `prefix` and `url` as optional parameters.
  AppException([this.message, this.prefix, this.url]);
}

// `BadRequestException` class which extends `AppException` class.
// It sets the `prefix` value as 'Bad Request' in the constructor.
class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad Request', url);
}

// `FetchDataException` class which extends `AppException` class.
// It sets the `prefix` value as 'Unable to process' in the constructor.
class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, "Unable to process", url);
}

// `ServerNotRespondException` class which extends `AppException` class.
// It sets the `prefix` value as 'Server not responded' in the constructor.
class ServerNotRespondException extends AppException {
  ServerNotRespondException([String? message, String? url])
      : super(message, "Server not responded", url);
}

// `UnauthorizedException` class which extends `AppException` class.
// It sets the `prefix` value as 'Unauthorized request' in the constructor.
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message, String? url])
      : super(message, "Unauthorized request", url);
}

class RequiredParamterException extends AppException {
  RequiredParamterException([String? message, String? url])
      : super(message, "Parameters required", url);
}
