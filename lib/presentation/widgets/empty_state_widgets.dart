import 'package:flutter/material.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.icon = Icons.folder_open_outlined,
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
                color: AppTheme.textSecondaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (buttonText != null && onButtonPressed != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: const Icon(Icons.add),
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

class NoSuppliersEmptyState extends StatelessWidget {
  final VoidCallback? onAddSupplier;

  const NoSuppliersEmptyState({
    Key? key,
    this.onAddSupplier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Suppliers Yet',
      message: 'Create your first supplier record to get started.',
      icon: Icons.business_outlined,
      buttonText: 'Add Supplier',
      onButtonPressed: onAddSupplier,
    );
  }
}

class NoSearchResultsEmptyState extends StatelessWidget {
  final String query;
  final VoidCallback? onClear;

  const NoSearchResultsEmptyState({
    Key? key,
    required this.query,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: 'No suppliers match your search for "$query".',
      icon: Icons.search_off_outlined,
      buttonText: onClear != null ? 'Clear Search' : null,
      onButtonPressed: onClear,
    );
  }
}
