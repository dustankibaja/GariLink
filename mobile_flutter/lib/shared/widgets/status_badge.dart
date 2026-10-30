import 'package:garilink_mobile/core/theme/icons.dart';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/radius.dart';
import '../../core/theme/typography.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color getBgColor(String label) {
      switch (label.toUpperCase()) {
        case 'ACTIVE':
        case 'APPROVED':
        case 'COMPLETED':
        case 'AVAILABLE':
          return GariLinkColors.success.withValues(alpha: 0.12);
        case 'PENDING':
        case 'DRAFT':
        case 'PAUSED':
          return GariLinkColors.warning.withValues(alpha: 0.12);
        case 'REJECTED':
        case 'CANCELLED':
        case 'REVOKED':
        case 'SUSPENDED':
          return GariLinkColors.error.withValues(alpha: 0.12);
        default:
          return isDark ? const Color(0xFF1E2D4A) : GariLinkColors.borderLight;
      }
    }

    Color getTextColor(String label) {
      switch (label.toUpperCase()) {
        case 'ACTIVE':
        case 'APPROVED':
        case 'COMPLETED':
        case 'AVAILABLE':
          return GariLinkColors.success;
        case 'PENDING':
        case 'DRAFT':
        case 'PAUSED':
          return GariLinkColors.warning;
        case 'REJECTED':
        case 'CANCELLED':
        case 'REVOKED':
        case 'SUSPENDED':
          return GariLinkColors.error;
        default:
          return isDark
              ? GariLinkColors.textMuted
              : GariLinkColors.textSecondary;
      }
    }

    GariIconData getIcon(String label) {
      switch (label.toUpperCase()) {
        case 'ACTIVE':
        case 'APPROVED':
        case 'COMPLETED':
        case 'AVAILABLE':
          return GariLinkIcons.confirmed;
        case 'PENDING':
        case 'DRAFT':
        case 'PAUSED':
          return GariLinkIcons.clock;
        case 'REJECTED':
        case 'CANCELLED':
        case 'REVOKED':
        case 'SUSPENDED':
          return GariLinkIcons.cancelled;
        default:
          return GariLinkIcons.info;
      }
    }

    final formattedText = status.replaceAll('_', ' ').toUpperCase();

    return Semantics(
      label: 'Status: ${formattedText.toLowerCase()}',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GariLinkSpacing.sm,
          vertical: GariLinkSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: getBgColor(status),
          borderRadius: GariLinkRadius.badgeBorderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GariIcon(getIcon(status), size: 13, color: getTextColor(status)),
            const SizedBox(width: GariLinkSpacing.xs),
            Flexible(
              child: Text(
                formattedText,
                overflow: TextOverflow.ellipsis,
                style: GariLinkTypography.labelSmall.copyWith(
                  color: getTextColor(status),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
