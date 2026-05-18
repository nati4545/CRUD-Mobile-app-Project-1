import 'package:flutter/material.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStateWidget({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText = 'Retry',
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: AppTheme.dangerColor.withOpacity(0.6),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.dangerColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              if (buttonText != null && onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(buttonText!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Network Error',
      message: 'Unable to connect to the internet. Please check your connection and try again.',
      icon: Icons.cloud_off_outlined,
      onRetry: onRetry,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Server Error',
      message: 'The server encountered an error. Please try again later.',
      icon: Icons.storage_outlined,
      onRetry: onRetry,
    );
  }
}

class GenericErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const GenericErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'Something Went Wrong',
      message: message,
      icon: Icons.warning_amber_outlined,
      onRetry: onRetry,
    );
  }
}

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    required String message,
    VoidCallback? onRetry,
  }) : super(
    content: Text(message),
    backgroundColor: AppTheme.dangerColor,
    duration: const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    action: onRetry != null
        ? SnackBarAction(
      label: 'Retry',
      textColor: Colors.white,
      onPressed: onRetry,
    )
        : null,
  );
}
