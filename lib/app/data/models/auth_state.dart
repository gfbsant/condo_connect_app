enum AuthState {
  initial,
  loading,
  authenticated,
  error,
  success, // for non auth operations, like reset-password
}
