import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import 'package:garilink_mobile/core/theme/theme.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: GariLinkColors.background,
      appBar: AppBar(
        backgroundColor: GariLinkColors.surface,
        elevation: 0,
        title: Text('Menu', style: GariLinkTypography.titleLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: GariLinkSpacing.lg),
            _buildSectionHeader('BUSINESS SETTINGS'),
            _buildMenuItem('Business Profile', GariLinkIcons.businessProfile),
            _buildMenuItem('Payment & Payouts', GariLinkIcons.payments),
            _buildMenuItem('Team Management', GariLinkIcons.team),
            _buildMenuItem('Subscription', GariLinkIcons.subscription),

            const SizedBox(height: GariLinkSpacing.xl),
            _buildSectionHeader('SUPPORT'),
            _buildMenuItem('Help Center', GariLinkIcons.help),
            _buildMenuItem('Contact Support', GariLinkIcons.contactSupport),
            _buildMenuItem('Feedback', GariLinkIcons.feedback),

            const SizedBox(height: GariLinkSpacing.xl),
            _buildLogoutButton(ref),
            const SizedBox(height: GariLinkSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GariLinkSpacing.lg,
        vertical: GariLinkSpacing.sm,
      ),
      child: Text(
        title,
        style: GariLinkTypography.bodySmall.copyWith(
          color: GariLinkColors.textMuted,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, GariIconData icon) {
    return Semantics(
      enabled: false,
      label: '$title, not available yet',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GariLinkSpacing.lg,
          vertical: GariLinkSpacing.md,
        ),
        decoration: BoxDecoration(
          color: GariLinkColors.surface,
          border: Border(
            bottom: BorderSide(color: GariLinkColors.neutral100, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(GariLinkSpacing.sm),
              decoration: BoxDecoration(
                color: GariLinkColors.neutral100,
                borderRadius: BorderRadius.circular(GariLinkRadius.badge),
              ),
              child: GariIcon(
                icon,
                color: GariLinkColors.textPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: GariLinkSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GariLinkTypography.bodyLarge.copyWith(
                      color: GariLinkColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: GariLinkSpacing.xs),
                  Text(
                    'Not available yet',
                    style: GariLinkTypography.bodySmall.copyWith(
                      color: GariLinkColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const GariIcon(
              GariLinkIcons.lockClock,
              color: GariLinkColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return InkWell(
      onTap: ref.watch(authStateProvider).isLoading
          ? null
          : () => ref.read(authStateProvider.notifier).logout(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: GariLinkSpacing.lg,
          vertical: GariLinkSpacing.lg,
        ),
        decoration: const BoxDecoration(color: GariLinkColors.surface),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(GariLinkSpacing.sm),
              decoration: BoxDecoration(
                color: GariLinkColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(GariLinkRadius.badge),
              ),
              child: const GariIcon(
                GariLinkIcons.logout,
                color: GariLinkColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: GariLinkSpacing.md),
            Text(
              'Logout',
              style: GariLinkTypography.bodyLarge.copyWith(
                color: GariLinkColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
