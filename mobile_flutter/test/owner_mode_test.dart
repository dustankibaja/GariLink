import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garilink_mobile/core/navigation/app_router.dart';
import 'package:garilink_mobile/core/services/storage_service.dart';
import 'package:garilink_mobile/features/authentication/data/repositories/auth_repository.dart';
import 'package:garilink_mobile/features/authentication/domain/entities/user.dart';
import 'package:garilink_mobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:garilink_mobile/features/owner/presentation/providers/owner_mode_provider.dart';

User _user(List<UserRole> roles) => User(
  id: 'user',
  phoneNumber: '+255700000001',
  roles: roles,
  isPhoneVerified: true,
  isEmailVerified: false,
  capabilities: const [],
);

class _AuthRepositoryFake implements AuthRepository {
  _AuthRepositoryFake(this.user);
  final User user;
  @override
  Future<User> getMe() async => user;
  @override
  Future<void> logout() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<AuthNotifier> _signedIn(User user) async {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({});
  final storage = StorageService(
    const FlutterSecureStorage(),
    await SharedPreferences.getInstance(),
  );
  await storage.setTokens('access', 'refresh');
  final auth = AuthNotifier(_AuthRepositoryFake(user), storage);
  await auth.hydrate();
  return auth;
}

Widget _shell(ProviderContainer container) {
  Widget blank(BuildContext _, GoRouterState _) => const SizedBox.shrink();
  final router = GoRouter(
    initialLocation: '/owner-dashboard',
    routes: [
      ShellRoute(
        builder: (_, _, child) => ScaffoldWithNavBar(child: child),
        routes: [
          for (final path in [
            '/home',
            '/explore',
            '/trips',
            '/profile',
            '/owner-dashboard',
            '/incoming-requests',
            '/my-vehicles',
            '/menu',
          ])
            GoRoute(path: path, builder: blank),
        ],
      ),
    ],
  );
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('owner role detection matches the server-granted roles', () {
    expect(isVehicleOwner(null), isFalse);
    expect(isVehicleOwner(_user([UserRole.customer])), isFalse);
    expect(isVehicleOwner(_user([UserRole.privateOwner])), isTrue);
    expect(isVehicleOwner(_user([UserRole.dealer])), isTrue);
  });

  testWidgets('an owner can switch to renting and back', (tester) async {
    final auth = await _signedIn(
      _user([UserRole.customer, UserRole.privateOwner]),
    );
    final container = ProviderContainer(
      overrides: [authStateProvider.overrideWith((_) => auth)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(_shell(container));
    await tester.pumpAndSettle();

    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('Vehicles'), findsOneWidget);
    expect(find.text('Trips'), findsNothing);
    expect(find.byTooltip('Add a vehicle'), findsOneWidget);

    container.read(ownerModeProvider.notifier).state = false;
    await tester.pumpAndSettle();
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Trips'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Bookings'), findsNothing);
    expect(find.byTooltip('Add a vehicle'), findsNothing);

    container.read(ownerModeProvider.notifier).state = true;
    await tester.pumpAndSettle();
    expect(find.text('Bookings'), findsOneWidget);
  });

  testWidgets('owner mode has no effect for a renter', (tester) async {
    final auth = await _signedIn(_user([UserRole.customer]));
    final container = ProviderContainer(
      overrides: [authStateProvider.overrideWith((_) => auth)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(_shell(container));
    await tester.pumpAndSettle();
    expect(find.text('Trips'), findsOneWidget);
    expect(find.text('Bookings'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
