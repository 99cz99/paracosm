/// App-level constants. Keep everything that isn't per-feature here.
class AppConfig {
  AppConfig._();

  static const String appName = 'Paracosm';

  /// Drift schema version. Bump on every structural migration.
  static const int schemaVersion = 12;
}
