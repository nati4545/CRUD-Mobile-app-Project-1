import 'package:equatable/equatable.dart';
import 'package:supplier_directory/core/errors/failures.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';

abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object?> get props => [];
}

// Initial state
class SupplierInitial extends SupplierState {
  const SupplierInitial();
}

// List States
class SupplierListLoading extends SupplierState {
  const SupplierListLoading();
}

class SupplierListLoaded extends SupplierState {
  final List<SupplierEntity> suppliers;
  final int totalSuppliers;
  final int activeSuppliers;
  final int inactiveSuppliers;

  const SupplierListLoaded({
    required this.suppliers,
    required this.totalSuppliers,
    required this.activeSuppliers,
    required this.inactiveSuppliers,
  });

  @override
  List<Object?> get props => [suppliers, totalSuppliers, activeSuppliers, inactiveSuppliers];
}

class SupplierListEmpty extends SupplierState {
  const SupplierListEmpty();
}

class SupplierListError extends SupplierState {
  final Failure failure;

  const SupplierListError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Detail States
class SupplierDetailLoading extends SupplierState {
  const SupplierDetailLoading();
}

class SupplierDetailLoaded extends SupplierState {
  final SupplierEntity supplier;

  const SupplierDetailLoaded({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class SupplierDetailError extends SupplierState {
  final Failure failure;

  const SupplierDetailError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Create/Update States
class SupplierCreating extends SupplierState {
  const SupplierCreating();
}

class SupplierCreated extends SupplierState {
  final SupplierEntity supplier;

  const SupplierCreated({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class SupplierCreationError extends SupplierState {
  final Failure failure;

  const SupplierCreationError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SupplierUpdating extends SupplierState {
  const SupplierUpdating();
}

class SupplierUpdated extends SupplierState {
  final SupplierEntity supplier;

  const SupplierUpdated({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class SupplierUpdationError extends SupplierState {
  final Failure failure;

  const SupplierUpdationError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Delete States
class SupplierDeleting extends SupplierState {
  const SupplierDeleting();
}

class SupplierDeleted extends SupplierState {
  const SupplierDeleted();
}

class SupplierDeletionError extends SupplierState {
  final Failure failure;

  const SupplierDeletionError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

// Search/Filter States
class SupplierSearched extends SupplierState {
  final List<SupplierEntity> suppliers;

  const SupplierSearched({required this.suppliers});

  @override
  List<Object?> get props => [suppliers];
}

class SupplierFiltered extends SupplierState {
  final List<SupplierEntity> suppliers;

  const SupplierFiltered({required this.suppliers});

  @override
  List<Object?> get props => [suppliers];
}
