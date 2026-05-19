import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.errorContainer.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: scheme.onErrorContainer),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: scheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
