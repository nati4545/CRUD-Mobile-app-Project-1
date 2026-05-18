import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String category;
  final String status;
  final String? notes;

  const SupplierEntity({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.category,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contactPerson,
        phone,
        email,
        address,
        category,
        status,
        notes,
      ];
}
