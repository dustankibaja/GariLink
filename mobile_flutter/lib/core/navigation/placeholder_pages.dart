import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/app_button.dart';
import '../theme/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text(
                'GariLink',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: GariLinkColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Find the right vehicle for every journey in Tanzania.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: GariLinkColors.textSecondary,
                ),
              ),
              const SizedBox(height: 100),
              AppButton(
                text: 'Sign In',
                onPressed: () => context.push('/login'),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Browse without signing in',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
