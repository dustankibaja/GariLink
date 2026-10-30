import 'package:flutter/material.dart';

class GariLinkDimensions {
  GariLinkDimensions._();

  static const double compactPhone = 360;
  static const double widePhone = 600;
  static const double tablet = 840;

  static const double minTouchTarget = 48;
  static const double buttonHeight = 52;
  static const double bottomNavigationHeight = 72;
  static double navigationHeight(BuildContext context) =>
      bottomNavigationHeight +
      (MediaQuery.textScalerOf(context).scale(12) - 12).clamp(0, 24) * 2;
  static const double fieldMinHeight = 52;

  static const double iconSmall = 18;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double emptyStateIcon = 56;

  static const double contentMaxWidth = 680;
  static const double formMaxWidth = 520;
  static const double vehicleCardImageHeight = 148;
}
