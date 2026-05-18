import 'package:equatable/equatable.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';

class SupplierModel extends Equatable {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String category;
  final String status;
  final String? notes;

  const SupplierModel({
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

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    String formatAddress(dynamic address) {
      if (address is String) return address;
      if (address is Map<String, dynamic>) {
        final street = address['street'] as String? ?? '';
        final suite = address['suite'] as String? ?? '';
        final city = address['city'] as String? ?? '';
        final zipcode = address['zipcode'] as String? ?? '';
        final items = [street, suite, city, zipcode].where((item) => item.isNotEmpty).toList();
        return items.join(', ');
      }
      return '';
    }

    final dynamic jsonAddress = json['address'];
    final dynamic jsonCompany = json['company'];
    final String? companyCatchPhrase = jsonCompany is Map<String, dynamic>
        ? jsonCompany['catchPhrase'] as String?
        : null;
    final String? website = json['website'] as String?;
    return SupplierModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      contactPerson: json['username'] as String? ?? json['contactPerson'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: formatAddress(jsonAddress),
      category: (jsonCompany is Map<String, dynamic>)
          ? jsonCompany['name'] as String? ?? ''
          : json['category'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      notes: json['notes'] as String? ?? website ?? companyCatchPhrase,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'category': category,
      'status': status,
      'notes': notes,
    };
  }

  SupplierModel copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? category,
    String? status,
    String? notes,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      category: category ?? this.category,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

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

  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      address: address,
      category: category,
      status: status,
      notes: notes,
    );
  }
}
