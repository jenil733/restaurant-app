abstract class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure({String message = 'Server error occurred'}) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache failure']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'No Internet connection']);
}

class AuthFailure extends Failure {
  AuthFailure([super.message = 'Authentication failed']);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
