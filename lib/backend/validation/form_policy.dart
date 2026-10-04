const usernameLimit = 30;
String? validateName(String? value) => value == null || value.trim().isEmpty
    ? 'Enter your full name'
    : value.trim().length > 80
    ? 'Use at most 80 characters'
    : null;
String? validateEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Enter a valid email address';
String? validateUsername(String? value) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return 'Enter a username';
  if (v.length < 3 || v.length > usernameLimit) return 'Use 3–30 characters';
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
    return 'Use letters, numbers and underscores only';
  }
  return null;
}

String? validateConfirmation(String? value, String password) =>
    value == null || value.isEmpty
    ? 'Re-enter your password'
    : value != password
    ? 'Passwords do not match'
    : null;
String? validateReason(String? value) => value == null || value.trim().isEmpty
    ? 'Enter a rejection reason'
    : value.trim().length > 500
    ? 'Use at most 500 characters'
    : null;
