import 'dart:async';
import 'package:grpc/grpc.dart';

class MockResponseFuture<T> implements ResponseFuture<T> {
  final Future<T> future;

  MockResponseFuture.value(T value) : future = Future.value(value);

  MockResponseFuture.error(Object error) : future = Future.error(error);

  MockResponseFuture.future(this.future);

  @override
  Stream<T> asStream() {
    return future.asStream();
  }

  @override
  Future<void> cancel() async {
    // Mock Futures cannot be canceled
  }

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) {
    return future.catchError(onError, test: test);
  }

  @override
  Future<Map<String, String>> get headers => Future.value({});

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) {
    return future.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<Map<String, String>> get trailers => Future.value({});

  @override
  Future<T> whenComplete(FutureOr Function() action) {
    return future.whenComplete(action);
  }

  @override
  Future<S> then<S>(FutureOr<S> Function(T p1) onValue, {Function? onError}) {
    return future.then(onValue, onError: onError);
  }
}
