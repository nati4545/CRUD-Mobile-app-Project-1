import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';
import 'package:supplier_directory/presentation/bloc/supplier_bloc.dart';
import 'package:supplier_directory/presentation/bloc/supplier_event.dart';
import 'package:supplier_directory/presentation/bloc/supplier_state.dart';
import 'package:supplier_directory/presentation/screens/add_supplier_screen.dart';
import 'package:supplier_directory/presentation/screens/supplier_details_screen.dart';
import 'package:supplier_directory/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:supplier_directory/presentation/widgets/empty_state_widgets.dart';
import 'package:supplier_directory/presentation/widgets/error_state_widgets.dart';
import 'package:supplier_directory/presentation/widgets/loading_widgets.dart';
import 'package:supplier_directory/presentation/widgets/supplier_widgets.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({Key? key}) : super(key: key);

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    context.read<SupplierBloc>().add(const FetchSuppliersEvent());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      context.read<SupplierBloc>().add(const FetchSuppliersEvent());
    } else {
      context.read<SupplierBloc>().add(SearchSuppliersEvent(query: query));
    }
  }

  void _filterByStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
    if (status.isEmpty) {
      context.read<SupplierBloc>().add(const FetchSuppliersEvent());
    } else {
      context.read<SupplierBloc>().add(FilterSuppliersByStatusEvent(status: status));
    }
  }

  void _openAddSupplierScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: context.read<SupplierBloc>(),
          child: const AddSupplierScreen(),
        ),
      ),
    );
  }

  void _openSupplierDetails(String supplierId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: context.read<SupplierBloc>(),
          child: SupplierDetailsScreen(supplierId: supplierId),
        ),
      ),
    );
  }

  void _editSupplier(String supplierId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: context.read<SupplierBloc>(),
          child: AddSupplierScreen(supplierId: supplierId),
        ),
      ),
    );
  }

  void _deleteSupplier(String supplierId, String supplierName) {
    DeleteConfirmationDialog.show(
      context,
      supplierName: supplierName,
      onConfirm: () {
        context.read<SupplierBloc>().add(DeleteSupplierEvent(id: supplierId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Supplier Directory'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SupplierBloc>().add(const FetchSuppliersEvent());
              _searchController.clear();
              _filterByStatus('');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search suppliers...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                      borderSide: const BorderSide(color: AppTheme.borderColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _selectedStatus.isEmpty,
                        label: const Text('All'),
                        onSelected: (_) {
                          _filterByStatus('');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        selected: _selectedStatus == 'Active',
                        label: const Text('Active'),
                        onSelected: (_) {
                          _filterByStatus('Active');
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        selected: _selectedStatus == 'Inactive',
                        label: const Text('Inactive'),
                        onSelected: (_) {
                          _filterByStatus('Inactive');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Summary Cards
          BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              if (state is SupplierListLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      SummaryCard(
                        title: 'Total',
                        value: state.totalSuppliers.toString(),
                        icon: Icons.business,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      SummaryCard(
                        title: 'Active',
                        value: state.activeSuppliers.toString(),
                        icon: Icons.check_circle,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 8),
                      SummaryCard(
                        title: 'Inactive',
                        value: state.inactiveSuppliers.toString(),
                        icon: Icons.pause_circle,
                        color: AppTheme.warningColor,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 8),
          // Supplier List
          Expanded(
            child: BlocListener<SupplierBloc, SupplierState>(
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
                  if (state is SupplierListLoading) {
                    return const LoadingListView();
                  }

                  if (state is SupplierListEmpty) {
                    return NoSuppliersEmptyState(
                      onAddSupplier: _openAddSupplierScreen,
                    );
                  }

                  if (state is SupplierListError) {
                    return ErrorStateWidget(
                      title: 'Failed to Load Suppliers',
                      message: state.failure.message,
                      buttonText: 'Retry',
                      onRetry: () {
                        context.read<SupplierBloc>().add(const FetchSuppliersEvent());
                      },
                    );
                  }

                  if (state is SupplierListLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = state.suppliers[index];
                        return SupplierCard(
                          supplier: supplier,
                          onTap: () => _openSupplierDetails(supplier.id),
                          onEdit: () => _editSupplier(supplier.id),
                          onDelete: () => _deleteSupplier(supplier.id, supplier.name),
                        );
                      },
                    );
                  }

                  if (state is SupplierSearched) {
                    if (state.suppliers.isEmpty) {
                      return NoSearchResultsEmptyState(
                        query: _searchController.text,
                        onClear: () {
                          _searchController.clear();
                        },
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = state.suppliers[index];
                        return SupplierCard(
                          supplier: supplier,
                          onTap: () => _openSupplierDetails(supplier.id),
                          onEdit: () => _editSupplier(supplier.id),
                          onDelete: () => _deleteSupplier(supplier.id, supplier.name),
                        );
                      },
                    );
                  }

                  if (state is SupplierFiltered) {
                    if (state.suppliers.isEmpty) {
                      return Center(
                        child: Text(
                          'No $_selectedStatus suppliers',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: state.suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = state.suppliers[index];
                        return SupplierCard(
                          supplier: supplier,
                          onTap: () => _openSupplierDetails(supplier.id),
                          onEdit: () => _editSupplier(supplier.id),
                          onDelete: () => _deleteSupplier(supplier.id, supplier.name),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSupplierScreen,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
