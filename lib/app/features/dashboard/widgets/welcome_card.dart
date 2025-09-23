import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';
import '../viewmodel/dashboard_viewmodel.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard(this.viewModel, {super.key});
  final DashboardViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final User? user = viewModel.currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.welcomeMessage,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          if (user != null) ...[
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    viewModel.roleDisplayName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white.withAlpha(204)),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<DashboardViewModel>('viewModel', viewModel));
  }
}
