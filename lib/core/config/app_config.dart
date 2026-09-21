/// App-level constants. Keep everything that isn't per-feature here.
class AppConfig {
  AppConfig._();

  static const String appName = 'Paracosm';

  /// GitHub repo hosting release APKs, used by the in-app update checker.
  static const String githubRepo = '99cz99/paracosm';

  /// Drift schema version. Bump on every structural migration.
  static const int schemaVersion = 19;
}
