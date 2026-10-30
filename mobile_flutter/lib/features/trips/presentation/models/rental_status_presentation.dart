import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

enum RentalLifecycleGroup { upcoming, active, past }

class RentalStatusPresentation {
  const RentalStatusPresentation({
    required this.label,
    required this.title,
    required this.explanation,
    required this.nextStep,
    required this.color,
    required this.icon,
    required this.group,
  });

  final String label;
  final String title;
  final String explanation;
  final String nextStep;
  final Color color;
  final GariIconData icon;
  final RentalLifecycleGroup group;
}

RentalStatusPresentation rentalStatusPresentation(String status) =>
    switch (status) {
      'REQUESTED' => const RentalStatusPresentation(
        label: 'Waiting',
        title: 'Waiting for the owner',
        explanation: 'Your request was sent, but it is not confirmed yet.',
        nextStep: 'The owner needs to review your request.',
        color: GariLinkColors.warning,
        icon: GariLinkIcons.clock,
        group: RentalLifecycleGroup.upcoming,
      ),
      'UNDER_REVIEW' => const RentalStatusPresentation(
        label: 'In review',
        title: 'The owner is reviewing it',
        explanation:
            'Your request is being considered and is not confirmed yet.',
        nextStep: 'You will see the owner’s decision here.',
        color: GariLinkColors.warning,
        icon: GariLinkIcons.search,
        group: RentalLifecycleGroup.upcoming,
      ),
      'APPROVED' => const RentalStatusPresentation(
        label: 'Accepted',
        title: 'Your request was accepted',
        explanation: 'The owner accepted your dates for this vehicle.',
        nextStep: 'The owner will prepare the vehicle for your trip.',
        color: GariLinkColors.success,
        icon: GariLinkIcons.confirmed,
        group: RentalLifecycleGroup.upcoming,
      ),
      'READY_FOR_PICKUP' => const RentalStatusPresentation(
        label: 'Ready',
        title: 'Ready for your trip',
        explanation: 'The owner has marked the vehicle ready for pickup.',
        nextStep: 'Follow the pickup arrangements agreed with the owner.',
        color: GariLinkColors.accent,
        icon: GariLinkIcons.key,
        group: RentalLifecycleGroup.upcoming,
      ),
      'ACTIVE' => const RentalStatusPresentation(
        label: 'In progress',
        title: 'Your rental is in progress',
        explanation: 'This vehicle is currently on your active rental.',
        nextStep: 'Return it according to the arrangements with the owner.',
        color: GariLinkColors.accent,
        icon: GariLinkIcons.route,
        group: RentalLifecycleGroup.active,
      ),
      'COMPLETED' => const RentalStatusPresentation(
        label: 'Completed',
        title: 'Rental completed',
        explanation: 'This rental has been completed.',
        nextStep: 'The trip remains here for your records.',
        color: GariLinkColors.success,
        icon: GariLinkIcons.confirmed,
        group: RentalLifecycleGroup.past,
      ),
      'REJECTED' => const RentalStatusPresentation(
        label: 'Declined',
        title: 'Request declined',
        explanation: 'The owner could not accept this rental request.',
        nextStep: 'You can explore another suitable vehicle.',
        color: GariLinkColors.error,
        icon: GariLinkIcons.cancelled,
        group: RentalLifecycleGroup.past,
      ),
      'CANCELLED' => const RentalStatusPresentation(
        label: 'Cancelled',
        title: 'Request cancelled',
        explanation: 'This rental request was cancelled.',
        nextStep: 'You can make a new request when you are ready.',
        color: GariLinkColors.textMuted,
        icon: GariLinkIcons.cancelled,
        group: RentalLifecycleGroup.past,
      ),
      'EXPIRED' => const RentalStatusPresentation(
        label: 'Expired',
        title: 'Request expired',
        explanation: 'This request is no longer active.',
        nextStep: 'Choose a vehicle and send a new request.',
        color: GariLinkColors.textMuted,
        icon: GariLinkIcons.timerOff,
        group: RentalLifecycleGroup.past,
      ),
      _ => const RentalStatusPresentation(
        label: 'Unavailable',
        title: 'Status unavailable',
        explanation: 'The latest rental status could not be understood.',
        nextStep: 'Refresh your trips to check for an update.',
        color: GariLinkColors.textMuted,
        icon: GariLinkIcons.info,
        group: RentalLifecycleGroup.past,
      ),
    };
