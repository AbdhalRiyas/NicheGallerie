class Result {
  final String message;
  dynamic data;
  dynamic errors;

  Result({required this.message, this.data, this.errors});

  bool get isSuccess => data != null;
  bool get isFailure => errors != null;
}
