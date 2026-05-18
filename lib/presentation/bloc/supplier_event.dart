import 'package:equatable/equatable.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object?> get props => [];
}

class FetchSuppliersEvent extends SupplierEvent {
  const FetchSuppliersEvent();
}

class GetSupplierByIdEvent extends SupplierEvent {
  final String id;

  const GetSupplierByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateSupplierEvent extends SupplierEvent {
  final SupplierEntity supplier;

  const CreateSupplierEvent({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class UpdateSupplierEvent extends SupplierEvent {
  final String id;
  final SupplierEntity supplier;

  const UpdateSupplierEvent({required this.id, required this.supplier});

  @override
  List<Object?> get props => [id, supplier];
}

class DeleteSupplierEvent extends SupplierEvent {
  final String id;

  const DeleteSupplierEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchSuppliersEvent extends SupplierEvent {
  final String query;

  const SearchSuppliersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterSuppliersByStatusEvent extends SupplierEvent {
  final String status;

  const FilterSuppliersByStatusEvent({required this.status});

  @override
  List<Object?> get props => [status];
}
