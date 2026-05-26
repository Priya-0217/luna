import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text("Oops! Something went wrong", style: AppTypography.titleLarge),
            const SizedBox(height: 8),
            Text(message, style: AppTypography.bodySmall, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.rosePrimary, foregroundColor: Colors.white),
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.rosePrimary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}
