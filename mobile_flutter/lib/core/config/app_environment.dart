/// Build-time environment selection.
///
/// Rules (Sprint 5.0A):
/// - Release builds default to `APP_ENV=production`, which selects the
///   approved production endpoint unless `API_BASE_URL` overrides it.
/// - Debug and profile builds have NO default endpoint. They must be given an
///   explicit `--dart-define=API_BASE_URL=...` (local or staging), or opt into
///   production explicitly with `--dart-define=APP_ENV=production`.
/// - A non-production environment may never point at the production project,
///   even when the URL is passed explicitly.
class AppEnvironment {
  AppEnvironment._();

  static const bool isRelease = bool.fromEnvironment('dart.vm.product');
  static const String production = 'production';
  static const String name = String.fromEnvironment(
    'APP_ENV',
    defaultValue: isRelease ? production : 'development',
  );
  static const String configuredApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  /// The approved hosted production API. Selected only for `APP_ENV=production`.
  static const String productionApiBaseUrl =
      'https://yvcdkmsfuakjflmuatgz.supabase.co/functions/v1/garilink-api';
  static final String productionApiHost = Uri.parse(productionApiBaseUrl).host;

  /// Reserved, never-resolving host (RFC 2606) used only so an unconfigured
  /// development build can start and fail every request with a clear message.
  static const String unconfiguredApiBaseUrl =
      'https://garilink-api.unconfigured.invalid';

  static const String missingEndpointMessage =
      'No development API is configured. Run with '
      '--dart-define=API_BASE_URL=<local or staging garilink-api URL>, or '
      '--dart-define=APP_ENV=production to use production deliberately.';

  static String validatedApiBaseUrl() => resolveApiBaseUrl(
    configured: configuredApiBaseUrl,
    environment: name,
    release: isRelease,
  );

  /// Pure resolution logic so every combination can be unit tested.
  static String resolveApiBaseUrl({
    required String configured,
    required String environment,
    required bool release,
  }) {
    final isProduction = environment == production;
    final value = configured.trim();
    if (value.isEmpty) {
      if (isProduction) return productionApiBaseUrl;
      throw StateError(missingEndpointMessage);
    }
    validateApiBaseUrl(value, release: release);
    if (!isProduction && Uri.parse(value).host == productionApiHost) {
      throw StateError(
        'APP_ENV=$environment cannot target the production project. '
        'Use a staging endpoint, or set APP_ENV=production deliberately.',
      );
    }
    return value;
  }

  static void validateApiBaseUrl(String value, {required bool release}) {
    final uri = Uri.tryParse(value);
    final scheme = uri?.scheme;
    if (uri == null ||
        uri.host.isEmpty ||
        (scheme != 'https' && scheme != 'http')) {
      throw StateError('API_BASE_URL must be an absolute http(s) URL.');
    }
    final localHost =
        uri.host == 'localhost' ||
        uri.host == '127.0.0.1' ||
        uri.host == '10.0.2.2';
    if (release && (scheme != 'https' || localHost)) {
      throw StateError(
        'Production API_BASE_URL must be a non-local HTTPS endpoint.',
      );
    }
  }
}
