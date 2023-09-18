import 'package:grpc/grpc.dart';

const token = "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJlbWFpbCI6InRlc3RpbmUudGVzdEBoZWxwd2F2ZS"
    "5kZSIsIm5hbWUiOiJUZXN0aW5lIFRlc3QiLCJuaWNrbmFtZSI6InRlc3RpbmUudGVzdCIsIm9yZ2FuaXphdGlvbnMiOlsiM2IyNWM2ZjUtNDcwNS00MDc0LTlmYzYtYTUwYzI4ZWJhNDA2Il19";
// TODO Later add something to differentiate task and user service
class AuthInterceptor extends ClientInterceptor {
  AuthInterceptor();

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker){
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "X-Organization": "3b25c6f5-4705-4074-9fc6-a50c28eba406",
      "dapr-app-id": "task-svc"
    };
    options = options.mergedWith(CallOptions(metadata: headers));
    return super.interceptUnary(method, request, options, invoker);
  }
}
