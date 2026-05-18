import 'package:dartz/dartz.dart';
import 'package:supplier_directory/core/errors/failures.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';
import 'package:supplier_directory/domain/repositories/supplier_repository.dart';

class GetAllSuppliersUseCase {
  final SupplierRepository repository;

  GetAllSuppliersUseCase({required this.repository});

  Future<Either<Failure, List<SupplierEntity>>> call() async {
    return await repository.getAllSuppliers();
  }
}

class GetSupplierByIdUseCase {
  final SupplierRepository repository;

  GetSupplierByIdUseCase({required this.repository});

  Future<Either<Failure, SupplierEntity>> call(String id) async {
    return await repository.getSupplierById(id);
  }
}

class CreateSupplierUseCase {
  final SupplierRepository repository;

  CreateSupplierUseCase({required this.repository});

  Future<Either<Failure, SupplierEntity>> call(SupplierEntity supplier) async {
    return await repository.createSupplier(supplier);
  }
}

class UpdateSupplierUseCase {
  final SupplierRepository repository;

  UpdateSupplierUseCase({required this.repository});

  Future<Either<Failure, SupplierEntity>> call(
      String id, SupplierEntity supplier) async {
    return await repository.updateSupplier(id, supplier);
  }
}

class DeleteSupplierUseCase {
  final SupplierRepository repository;

  DeleteSupplierUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteSupplier(id);
  }
}
