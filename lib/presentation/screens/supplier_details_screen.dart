import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';
import 'package:supplier_directory/presentation/bloc/supplier_bloc.dart';
import 'package:supplier_directory/presentation/bloc/supplier_event.dart';
import 'package:supplier_directory/presentation/bloc/supplier_state.dart';
import 'package:supplier_directory/presentation/screens/add_supplier_screen.dart';
import 'package:supplier_directory/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:supplier_directory/presentation/widgets/error_state_widgets.dart';
import 'package:supplier_directory/presentation/widgets/loading_widgets.dart';
import 'package:supplier_directory/presentation/widgets/supplier_widgets.dart';

class SupplierDetailsScreen extends StatefulWidget {
  final String supplierId;

  const SupplierDetailsScreen({
    Key? key,
    required this.supplierId,
  }) : super(key: key);

  @override
  State<SupplierDetailsScreen> createState() => _SupplierDetailsScreenState();
}

class _SupplierDetailsScreenState extends State<SupplierDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SupplierBloc>().add(GetSupplierByIdEvent(id: widget.supplierId));
  }

  void _editSupplier() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: context.read<SupplierBloc>(),
          child: AddSupplierScreen(supplierId: widget.supplierId),
        ),
      ),
    );
  }

  void _deleteSupplier(String supplierName) {
    DeleteConfirmationDialog.show(
      context,
      supplierName: supplierName,
      onConfirm: () {
        context.read<SupplierBloc>().add(DeleteSupplierEvent(id: widget.supplierId));
        // Navigate back after deletion
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Supplier Details'),
        elevation: 0,
      ),
      body: BlocListener<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is SupplierDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Supplier deleted successfully'),
                backgroundColor: AppTheme.accentColor,
                duration: Duration(seconds: 2),
              ),
            );
          }
          if (state is SupplierDeletionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.failure.message}'),
                backgroundColor: AppTheme.dangerColor,
              ),
            );
          }
        },
        child: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            if (state is SupplierDetailLoading) {
              return const LoadingIndicator();
            }

            if (state is SupplierDetailError) {
              return ErrorStateWidget(
                title: 'Failed to Load Supplier',
                message: state.failure.message,
                buttonText: 'Retry',
                onRetry: () {
                  context
                      .read<SupplierBloc>()
                      .add(GetSupplierByIdEvent(id: widget.supplierId));
                },
              );
            }

            if (state is SupplierDetailLoaded) {
              final supplier = state.supplier;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        supplier.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      StatusBadge(status: supplier.status),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    size: 18,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    supplier.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Contact Information Section
                    _buildSection(
                      context,
                      title: 'Contact Information',
                      icon: Icons.person_outline,
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.person,
                          label: 'Contact Person',
                          value: supplier.contactPerson,
                        ),
                        _buildDetailRow(
                          context,
                          icon: Icons.phone,
                          label: 'Phone',
                          value: supplier.phone,
                          onTap: () {
                            // Can add call functionality later
                          },
                        ),
                        _buildDetailRow(
                          context,
                          icon: Icons.email,
                          label: 'Email',
                          value: supplier.email,
                          onTap: () {
                            // Can add email functionality later
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Business Information Section
                    _buildSection(
                      context,
                      title: 'Business Information',
                      icon: Icons.business_outlined,
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.location_on,
                          label: 'Address',
                          value: supplier.address,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Notes Section
                    if (supplier.notes != null && supplier.notes!.isNotEmpty) ...[
                      _buildSection(
                        context,
                        title: 'Notes',
                        icon: Icons.note_outlined,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderColor),
                            ),
                            child: Text(
                              supplier.notes!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Supplier'),
                            onPressed: _editSupplier,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.dangerColor,
                            ),
                            onPressed: () => _deleteSupplier(supplier.name),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
