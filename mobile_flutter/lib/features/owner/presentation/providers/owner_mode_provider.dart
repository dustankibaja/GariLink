import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/owner_draft_repository.dart';
import '../pages/create_listing_page.dart';

/// Server-granted owner roles. The server stays authoritative for every
/// owner action; this only chooses which navigation the user sees.
bool isVehicleOwner(User? user) =>
    user != null &&
    (user.roles.contains(UserRole.privateOwner) ||
        user.roles.contains(UserRole.dealer));

/// Whether an owner is currently using the owner workspace (true) or renting
/// like any other customer (false). Ignored for users without an owner role.
final ownerModeProvider = StateProvider<bool>((ref) => true);

/// Starts the existing private-draft listing flow. Workspace creation inside
/// [CreateListingPage] is what grants the owner role on the server.
Future<void> startVehicleListing(BuildContext context, WidgetRef ref) async {
  if (!ref.read(authStateProvider).isAuthenticated) {
    context.push('/login');
    return;
  }
  if (!supabaseOwnerToolsEnabled) return;
  final saved = await Navigator.of(
    context,
    rootNavigator: true,
  ).push<bool>(MaterialPageRoute(builder: (_) => const CreateListingPage()));
  if (!context.mounted) return;
  // Refresh even after cancellation: a workspace may have been created
  // before an uncertain/failed draft request. Never invent the role.
  await ref.read(authStateProvider.notifier).refreshMe();
  if (!context.mounted || saved != true) return;
  if (isVehicleOwner(ref.read(authStateProvider).user)) {
    ref.read(ownerModeProvider.notifier).state = true;
    context.go('/my-vehicles');
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Private draft saved. It is not published yet.'),
    ),
  );
}
