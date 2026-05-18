import 'package:dartz/dartz.dart';
import 'package:supplier_directory/core/errors/failures.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';

abstract class SupplierRepository {
  Future<Either<Failure, List<SupplierEntity>>> getAllSuppliers();
  Future<Either<Failure, SupplierEntity>> getSupplierById(String id);
  Future<Either<Failure, SupplierEntity>> createSupplier(SupplierEntity supplier);
  Future<Either<Failure, SupplierEntity>> updateSupplier(
      String id, SupplierEntity supplier);
  Future<Either<Failure, void>> deleteSupplier(String id);
}
