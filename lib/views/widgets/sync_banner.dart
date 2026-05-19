import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class SyncBanner extends StatelessWidget {
  const SyncBanner({super.key, required this.cloudEnabled});

  final bool cloudEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(14),
      color: cloudEnabled
          ? const Color(0xFFD1FAE5).withValues(alpha: 0.92)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              cloudEnabled
                  ? Icons.cloud_done_rounded
                  : Icons.cloud_off_outlined,
              size: 22,
              color: cloudEnabled
                  ? const Color(0xFF047857)
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                cloudEnabled ? l10n.cloudSyncOn : l10n.cloudSyncOff,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cloudEnabled
                      ? const Color(0xFF065F46)
                      : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
