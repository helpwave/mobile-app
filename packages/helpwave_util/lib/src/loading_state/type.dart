enum LoadingState {
  /// The data is initializing
  initializing,

  /// The data is loaded
  loaded,

  /// The data is currently loading
  loading,

  /// Loading the data produced an error
  error,

  /// There is no loading state, meaning ignore the LoadingState
  unspecified,
}
