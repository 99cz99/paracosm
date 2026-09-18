/// A user-facing error with an optional machine-readable code.
///
/// The UI layer maps these to dialogs (see [dialogs.dart]) instead of
/// chat bubbles — a hard product constraint.
class AppException implements Exception {
  AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => code == null ? message : '[$code] $message';
}

/// Network/LLM error, distinguished so the UI can offer retry guidance.
class LlmException extends AppException {
  LlmException(super.message, {super.code});
}
