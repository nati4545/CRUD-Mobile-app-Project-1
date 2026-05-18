import 'package:flutter/material.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String supplierName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmationDialog({
    Key? key,
    required this.supplierName,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.largeRadius),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.dangerColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text('Delete Supplier?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'Are you sure you want to delete '),
                TextSpan(
                  text: supplierName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.dangerLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppTheme.dangerColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This action cannot be undone.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.dangerColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.dangerColor,
          ),
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
      actionsPadding: const EdgeInsets.all(16),
      actionsAlignment: MainAxisAlignment.end,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String supplierName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => DeleteConfirmationDialog(
        supplierName: supplierName,
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm();
        },
        onCancel: () {
          Navigator.of(context).pop(false);
        },
      ),
    );
  }
}
