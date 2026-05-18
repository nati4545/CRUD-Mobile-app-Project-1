import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplier_directory/core/constants/app_constants.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';
import 'package:supplier_directory/core/utils/validation_utils.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';
import 'package:supplier_directory/presentation/bloc/supplier_bloc.dart';
import 'package:supplier_directory/presentation/bloc/supplier_event.dart';
import 'package:supplier_directory/presentation/bloc/supplier_state.dart';
import 'package:supplier_directory/presentation/widgets/loading_widgets.dart';

class AddSupplierScreen extends StatefulWidget {
  final String? supplierId;

  const AddSupplierScreen({
    Key? key,
    this.supplierId,
  }) : super(key: key);

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  String? _selectedCategory;
  String? _selectedStatus = 'Active';

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _isEditMode = widget.supplierId != null;

    if (_isEditMode) {
      // Load existing supplier data
      context.read<SupplierBloc>().add(
            GetSupplierByIdEvent(id: widget.supplierId!),
          );
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
  }

  void _populateFieldsFromSupplier(SupplierEntity supplier) {
    _nameController.text = supplier.name;
    _contactPersonController.text = supplier.contactPerson;
    _phoneController.text = supplier.phone;
    _emailController.text = supplier.email;
    _addressController.text = supplier.address;
    _notesController.text = supplier.notes ?? '';
    _selectedCategory = supplier.category;
    _selectedStatus = supplier.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
      return;
    }

    final supplier = SupplierEntity(
      id: _isEditMode ? widget.supplierId! : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      category: _selectedCategory!,
      status: _selectedStatus!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    if (_isEditMode) {
      context.read<SupplierBloc>().add(
            UpdateSupplierEvent(id: widget.supplierId!, supplier: supplier),
          );
    } else {
      context.read<SupplierBloc>().add(
            CreateSupplierEvent(supplier: supplier),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) return false;
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Supplier' : 'Add Supplier'),
          elevation: 0,
        ),
        body: BlocListener<SupplierBloc, SupplierState>(
          listener: (context, state) {
            // Defer any setState, navigation or controller population to after
            // the current build frame to avoid calling setState during build.
            if (state is SupplierCreated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Supplier created successfully'),
                    backgroundColor: AppTheme.accentColor,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              });
            }

            if (state is SupplierCreationError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.failure.message}'),
                    backgroundColor: AppTheme.dangerColor,
                  ),
                );
              });
            }

            if (state is SupplierUpdated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Supplier updated successfully'),
                    backgroundColor: AppTheme.accentColor,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              });
            }

            if (state is SupplierUpdationError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.failure.message}'),
                    backgroundColor: AppTheme.dangerColor,
                  ),
                );
              });
            }

            if (state is SupplierDetailLoaded && _isEditMode) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _populateFieldsFromSupplier(state.supplier);
              });
            }
          },
          child: BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              // Show loading indicator if fetching data for edit
              if (_isEditMode && state is SupplierDetailLoading) {
                return const LoadingIndicator();
              }

              // Avoid calling setState during build. Derive loading from state.
              final isLoading = state is SupplierCreating || state is SupplierUpdating;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Supplier Name *',
                          hintText: 'Enter supplier name',
                          prefixIcon: const Icon(Icons.business),
                        ),
                        validator: (value) =>
                            ValidationUtils.validateRequired(value, fieldName: 'Supplier name'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Contact Person Field
                      TextFormField(
                        controller: _contactPersonController,
                        decoration: InputDecoration(
                          labelText: 'Contact Person *',
                          hintText: 'Enter contact person name',
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) =>
                            ValidationUtils.validateRequired(value, fieldName: 'Contact person'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number *',
                          hintText: 'Enter phone number',
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: ValidationUtils.validatePhone,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address *',
                          hintText: 'Enter email address',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: ValidationUtils.validateEmail,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Address Field
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Business Address *',
                          hintText: 'Enter business address',
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        maxLines: 3,
                        validator: ValidationUtils.validateAddress,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          hintText: 'Select a category',
                          prefixIcon: const Icon(Icons.category),
                        ),
                        items: SupplierCategories.categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                        validator: ValidationUtils.validateCategory,
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status *',
                          hintText: 'Select status',
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        items: SupplierStatus.statuses.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              },
                        validator: ValidationUtils.validateStatus,
                      ),
                      const SizedBox(height: 16),

                      // Notes Field
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes (Optional)',
                          hintText: 'Enter any additional notes',
                          prefixIcon: const Icon(Icons.note),
                        ),
                        maxLines: 3,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitForm,
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(_isEditMode ? 'Update Supplier' : 'Save Supplier'),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
