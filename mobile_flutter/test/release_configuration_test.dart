import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garilink_mobile/core/config/app_environment.dart';
import 'package:garilink_mobile/core/errors/app_exception.dart';
import 'package:garilink_mobile/core/services/api_client.dart';
import 'package:garilink_mobile/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _staging = 'https://staging-ref.supabase.co/functions/v1/garilink-api';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('production accepts the hosted HTTPS API', () {
    expect(
      () => AppEnvironment.validateApiBaseUrl(
        'https://project.supabase.co/functions/v1/garilink-api',
        release: true,
      ),
      returnsNormally,
    );
  });

  for (final unsafe in [
    'http://localhost:3000',
    'http://127.0.0.1:54321',
    'http://10.0.2.2:3000',
    'http://example.com/api',
  ]) {
    test('production rejects unsafe API endpoint $unsafe', () {
      expect(
        () => AppEnvironment.validateApiBaseUrl(unsafe, release: true),
        throwsStateError,
      );
    });
  }

  group('endpoint resolution', () {
    test('development without API_BASE_URL fails instead of using prod', () {
      for (final release in [false, true]) {
        expect(
          () => AppEnvironment.resolveApiBaseUrl(
            configured: '',
            environment: 'development',
            release: release,
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              AppEnvironment.missingEndpointMessage,
            ),
          ),
        );
      }
    });

    test('staging without API_BASE_URL fails clearly', () {
      expect(
        () => AppEnvironment.resolveApiBaseUrl(
          configured: '  ',
          environment: 'staging',
          release: false,
        ),
        throwsStateError,
      );
    });

    test('non-production may not target the production project', () {
      for (final environment in ['development', 'staging', 'test']) {
        expect(
          () => AppEnvironment.resolveApiBaseUrl(
            configured: AppEnvironment.productionApiBaseUrl,
            environment: environment,
            release: false,
          ),
          throwsStateError,
        );
      }
    });

    test('explicit production selects the approved endpoint', () {
      for (final release in [false, true]) {
        expect(
          AppEnvironment.resolveApiBaseUrl(
            configured: '',
            environment: AppEnvironment.production,
            release: release,
          ),
          AppEnvironment.productionApiBaseUrl,
        );
      }
    });

    test('development accepts explicit local and staging endpoints', () {
      for (final url in [
        'http://10.0.2.2:54321/functions/v1/garilink-api',
        'http://127.0.0.1:54321/functions/v1/garilink-api',
        _staging,
      ]) {
        expect(
          AppEnvironment.resolveApiBaseUrl(
            configured: url,
            environment: 'development',
            release: false,
          ),
          url,
        );
      }
    });

    test('release rejects local endpoints even when configured', () {
      expect(
        () => AppEnvironment.resolveApiBaseUrl(
          configured: 'http://10.0.2.2:54321/functions/v1/garilink-api',
          environment: AppEnvironment.production,
          release: true,
        ),
        throwsStateError,
      );
    });

    test('malformed endpoints are rejected', () {
      for (final url in ['garilink-api', 'ftp://example.com/api', '/api']) {
        expect(
          () => AppEnvironment.resolveApiBaseUrl(
            configured: url,
            environment: 'development',
            release: false,
          ),
          throwsStateError,
        );
      }
    });
  });

  test('this test build is not silently wired to production', () {
    // `flutter test` runs without --dart-define, as a debug build would.
    expect(AppEnvironment.isRelease, isFalse);
    expect(AppEnvironment.name, 'development');
    expect(AppEnvironment.validatedApiBaseUrl, throwsStateError);
  });

  test('unconfigured development client fails requests clearly', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final client = ApiClient(
      StorageService(
        const FlutterSecureStorage(),
        await SharedPreferences.getInstance(),
      ),
    );
    addTearDown(client.close);
    expect(client.configurationError, isA<ConfigurationException>());
    expect(client.dio.options.baseUrl, AppEnvironment.unconfiguredApiBaseUrl);
    expect(
      Uri.parse(client.dio.options.baseUrl).host,
      isNot(AppEnvironment.productionApiHost),
    );
    await expectLater(
      client.get<Map<String, dynamic>>('/me'),
      throwsA(
        isA<ConfigurationException>().having(
          (error) => error.message,
          'message',
          AppEnvironment.missingEndpointMessage,
        ),
      ),
    );
  });

  test('an explicit base URL bypasses environment resolution', () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final client = ApiClient(
      StorageService(
        const FlutterSecureStorage(),
        await SharedPreferences.getInstance(),
      ),
      baseUrl: _staging,
      dio: Dio(),
    );
    addTearDown(client.close);
    expect(client.configurationError, isNull);
    expect(client.dio.options.baseUrl, _staging);
  });
}
