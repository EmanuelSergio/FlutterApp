import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorView extends StatelessWidget {
  final String messageKey;
  final VoidCallback? onRetry;
  final EdgeInsets padding;

  const ErrorView({
    super.key,
    required this.messageKey,
    this.onRetry,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: padding,
            child: Text(messageKey.tr(), textAlign: TextAlign.center),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr()),
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
