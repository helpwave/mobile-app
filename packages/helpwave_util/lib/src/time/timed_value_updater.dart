import 'dart:async';

/// A Class for updating a value and returning it after [timeToCallback] amount of seconds
///
/// WARNING: must be disposed
class TimedValueUpdater<T> {

  /// The call
  final void Function(T value) callback;

  /// The Duration until the [callback] is called after a update
  final Duration timeToCallback;

  /// The current value, which will be returned by the [callback]
  T _value;

  /// The timer for the callback
  Timer? _timer;

  T get value => this._value;

  set value(T newValue) {
    this._value = newValue;
    _timer?.cancel();
    resetTimer();
  }

  TimedValueUpdater(this._value, {
    required this.callback,
    this.timeToCallback = const Duration(seconds: 3),
  });

  /// Resets the update timer, when the value was just updated
  void resetTimer() {
    _timer = Timer.periodic(this.timeToCallback, (_) => this.callback(_value));
  }

  /// Cancels the [Timer]
  void cancelTimer({bool isNotifying = false}) {
    if(isNotifying){
      this.callback(_value);
    }
    _timer?.cancel();
  }

  /// Should be called when the object holding this is disposed
  void dispose({bool isNotifying = false}) {
    cancelTimer(isNotifying: isNotifying);
  }
}
