// Rendered application screens with synthetic test fixtures, never live data.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garilink_mobile/core/services/storage_service.dart';
import 'package:garilink_mobile/core/theme/theme.dart';
import 'package:garilink_mobile/features/authentication/presentation/providers/auth_provider.dart';
import 'package:garilink_mobile/features/authentication/presentation/pages/login_page.dart';
import 'package:garilink_mobile/features/booking/presentation/pages/booking_page.dart';
import 'package:garilink_mobile/features/explore/presentation/pages/explore_page.dart';
import 'package:garilink_mobile/features/explore/presentation/pages/saved_vehicles_page.dart';
import 'package:garilink_mobile/features/explore/presentation/providers/explore_provider.dart';
import 'package:garilink_mobile/features/home/presentation/pages/home_page.dart';
import 'package:garilink_mobile/features/owner/domain/operator_workspace.dart';
import 'package:garilink_mobile/features/owner/presentation/pages/owner_dashboard_page.dart';
import 'package:garilink_mobile/features/owner/presentation/pages/my_vehicles_page.dart';
import 'package:garilink_mobile/features/owner/presentation/pages/incoming_requests_page.dart';
import 'package:garilink_mobile/features/owner/presentation/providers/operator_workspace_provider.dart';
import 'package:garilink_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:garilink_mobile/features/trips/presentation/pages/trips_page.dart';
import 'package:garilink_mobile/features/trips/presentation/providers/trips_provider.dart';
import 'package:garilink_mobile/features/vehicle/presentation/pages/vehicle_details_page.dart';
import 'package:garilink_mobile/shared/widgets/app_button.dart';
import 'package:garilink_mobile/shared/widgets/press_feedback.dart';
import 'profile_edit_test.dart' as profile_fixture;
import 'vehicle_detail_experience_test.dart' as detail_fixture;
import 'booking_request_experience_test.dart' as booking_fixture;
import 'rental_experience_test.dart' as rental_fixture;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const workspace = OperatorWorkspace(
    id: 'workspace-1',
    name: 'Sample mobility workspace',
    businessMode: WorkspaceBusinessMode.individual,
  );
  final listing = <String, dynamic>{
    ...detail_fixture.detail(),
    'title': 'Toyota Alphard',
    'price': 80000,
    'currency': 'TZS',
    'county': 'Dar es Salaam',
    'status': 'PUBLISHED',
    'year': 2022,
    'primaryImageUrl': '',
    'mediaItems': <dynamic>[],
  };
  final pages = <String, Widget>{
    'home': const HomePage(),
    'explore': const ExplorePage(),
    'details': const VehicleDetailsPage(listingId: 'listing-1'),
    'booking': const BookingPage(
      listingId: 'listing-1',
      dailyRate: 80000,
      currency: 'TZS',
      vehicleTitle: 'Toyota Alphard',
      publicLocality: 'Mikocheni',
      selection: booking_fixture.selection,
    ),
    'trips': const TripsPage(),
    'saved': const SavedVehiclesPage(),
    'profile': const ProfilePage(),
    'owner': const OwnerDashboardPage(),
    'inventory': const MyVehiclesPage(),
    'requests': const IncomingRequestsPage(),
    'auth': const LoginPage(),
  };
  for (final entry in pages.entries) {
    testWidgets('FLEX ${entry.key} renders without overflow at 390px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
      final storage = StorageService(
        const FlutterSecureStorage(),
        await SharedPreferences.getInstance(),
      );
      await storage.setTokens('synthetic-access', 'synthetic-refresh');
      final auth = AuthNotifier(
        profile_fixture.ProfileRepositoryFake(),
        storage,
      );
      await auth.hydrate();
      final router = GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => entry.value)],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((_) => auth),
            storageServiceProvider.overrideWithValue(storage),
            searchListingsProvider.overrideWith(
              (ref, query) async => [listing],
            ),
            listingDetailsProvider(
              'listing-1',
            ).overrideWith((ref) async => listing),
            savedListingsProvider.overrideWith((ref) async => [listing]),
            marketplaceAuthenticatedProvider.overrideWithValue(true),
            myWorkspacesProvider.overrideWith((ref) async => [workspace]),
            myListingsProvider.overrideWith((ref) async => [listing]),
            workspaceListingsProvider(
              'workspace-1',
            ).overrideWith((ref) async => [listing]),
            myTripsProvider.overrideWith(
              (ref) async => [rental_fixture.sample()],
            ),
            workspaceRentalsProvider(
              'workspace-1',
            ).overrideWith((ref) async => [rental_fixture.sample()]),
          ],
          child: RepaintBoundary(
            key: const Key('flex-capture'),
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              routerConfig: router,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await GoogleFonts.pendingFonts();
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final output = Platform.environment['GARILINK_FLEX_OUTPUTS'];
      if (output != null) {
        // Asset decoding runs outside the fake test clock. Capture only after
        // the actual ImageProvider (including ResizeImage) is cached.
        if (entry.key == 'home') {
          final photo = tester.widget<Image>(
            find.byKey(const Key('home-hero-photo')),
          );
          await tester.runAsync(() async {
            await precacheImage(
              photo.image,
              tester.element(find.byKey(const Key('home-hero-photo'))),
            );
          });
          await tester.pumpAndSettle();
        }
        await expectLater(
          find.byKey(const Key('flex-capture')),
          matchesGoldenFile(Uri.file('$output/after-${entry.key}.png')),
        );
      }
    });
  }
  testWidgets('SVG icons expose optional label and inherit color and size', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: IconTheme(
            data: IconThemeData(color: Colors.blue, size: 28),
            child: GariIcon(GariLinkIcons.vehicles, semanticLabel: 'Vehicle'),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Vehicle'), findsOneWidget);
    expect(tester.getSize(find.byType(GariIcon)), const Size(28, 28));
  });
  testWidgets(
    'press feedback respects reduced motion and preserves one button action',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: AppButton(text: 'Continue', onPressed: () => taps++),
            ),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppButton)),
      );
      await tester.pump();
      final scale = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(PressFeedback),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scale.scale, 1);
      expect(scale.duration, Duration.zero);
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
    },
  );
  testWidgets('tight containers do not stretch the SVG beyond its icon size', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox.square(
              dimension: 80,
              child: GariIcon(GariLinkIcons.vehicles, size: 20),
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(HugeIcon)), const Size(20, 20));
  });
  test('primary action foreground has accessible contrast', () {
    final ratio =
        (Colors.white.computeLuminance() + .05) /
        (GariLinkColors.primary.computeLuminance() + .05);
    expect(ratio, greaterThanOrEqualTo(4.5));
  });
}
