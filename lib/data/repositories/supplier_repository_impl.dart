import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supplier_directory/core/errors/failures.dart';
import 'package:supplier_directory/data/datasources/supplier_remote_datasource.dart';
import 'package:supplier_directory/data/models/supplier_model.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';
import 'package:supplier_directory/domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource remoteDataSource;

  SupplierRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<SupplierEntity>>> getAllSuppliers() async {
    try {
      final suppliers = await remoteDataSource.getAllSuppliers();
      return Right(suppliers.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> getSupplierById(String id) async {
    try {
      final supplier = await remoteDataSource.getSupplierById(id);
      return Right(supplier.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> createSupplier(SupplierEntity supplier) async {
    try {
      final model = SupplierModel(
        id: supplier.id,
        name: supplier.name,
        contactPerson: supplier.contactPerson,
        phone: supplier.phone,
        email: supplier.email,
        address: supplier.address,
        category: supplier.category,
        status: supplier.status,
        notes: supplier.notes,
      );
      final createdSupplier = await remoteDataSource.createSupplier(model);
      return Right(createdSupplier.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupplierEntity>> updateSupplier(
      String id, SupplierEntity supplier) async {
    try {
      final model = SupplierModel(
        id: id,
        name: supplier.name,
        contactPerson: supplier.contactPerson,
        phone: supplier.phone,
        email: supplier.email,
        address: supplier.address,
        category: supplier.category,
        status: supplier.status,
        notes: supplier.notes,
      );
      final updatedSupplier = await remoteDataSource.updateSupplier(id, model);
      return Right(updatedSupplier.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id) async {
    try {
      await remoteDataSource.deleteSupplier(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(message: 'Connection timeout. Please try again.');
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 404) {
        return NotFoundFailure(message: 'Supplier not found.');
      }
      if (e.response?.statusCode == 400) {
        return ValidationFailure(message: 'Invalid data provided.');
      }
      if (e.response?.statusCode == 500) {
        return ServerFailure(message: 'Server error. Please try again later.');
      }
      return ServerFailure(
          message: 'Error: ${e.response?.statusCode}. Please try again.');
    } else if (e.type == DioExceptionType.connectionError) {
      return NetworkFailure(
          message: 'No internet connection. Please check your connection.');
    } else if (e.type == DioExceptionType.unknown) {
      return NetworkFailure(message: 'Network error. Please try again.');
    }
    return UnknownFailure(message: e.message ?? 'An error occurred');
  }
}
