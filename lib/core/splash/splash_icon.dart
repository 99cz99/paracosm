import 'dart:ui' as ui;

/// The splash icon, pre-decoded in `main()` so the splash screen's first frame
/// already has the bubble — avoids a "bubble pops in" flash at the native →
/// Flutter handoff (where the native icon fades out revealing the app behind).
ui.Image? splashIconImage;
