import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:supplier_directory/core/constants/app_constants.dart';
import 'package:supplier_directory/data/models/supplier_model.dart';

abstract class SupplierRemoteDataSource {
  Future<List<SupplierModel>> getAllSuppliers();
  Future<SupplierModel> getSupplierById(String id);
  Future<SupplierModel> createSupplier(SupplierModel supplier);
  Future<SupplierModel> updateSupplier(String id, SupplierModel supplier);
  Future<void> deleteSupplier(String id);
}

class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  final Dio dio;
  final Logger logger = Logger();

  SupplierRemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: AppConstants.apiTimeout);
    dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.apiTimeout);
  }

  @override
  Future<List<SupplierModel>> getAllSuppliers() async {
    try {
      logger.i('Fetching all suppliers from API');
      final response = await dio.get(AppConstants.suppliersEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final suppliers = data
            .map((json) => SupplierModel.fromJson(json as Map<String, dynamic>))
            .toList();
        logger.i('Successfully fetched ${suppliers.length} suppliers');
        return suppliers;
      } else {
        throw Exception('Failed to load suppliers');
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}', error: e);
      _handleDioException(e);
      rethrow;
    } catch (e) {
      logger.e('Exception: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<SupplierModel> getSupplierById(String id) async {
    try {
      logger.i('Fetching supplier with id: $id');
      final response = await dio.get('${AppConstants.suppliersEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final supplier = SupplierModel.fromJson(response.data as Map<String, dynamic>);
        logger.i('Successfully fetched supplier: ${supplier.name}');
        return supplier;
      } else {
        throw Exception('Failed to load supplier');
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}', error: e);
      _handleDioException(e);
      rethrow;
    } catch (e) {
      logger.e('Exception: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    try {
      logger.i('Creating new supplier: ${supplier.name}');
      final response = await dio.post(
        AppConstants.suppliersEndpoint,
        data: supplier.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdSupplier = SupplierModel.fromJson(response.data as Map<String, dynamic>);
        logger.i('Successfully created supplier: ${createdSupplier.name}');
        return createdSupplier;
      } else {
        throw Exception('Failed to create supplier');
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}', error: e);
      _handleDioException(e);
      rethrow;
    } catch (e) {
      logger.e('Exception: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<SupplierModel> updateSupplier(String id, SupplierModel supplier) async {
    try {
      logger.i('Updating supplier with id: $id');
      final response = await dio.put(
        '${AppConstants.suppliersEndpoint}/$id',
        data: supplier.toJson(),
      );
      
      if (response.statusCode == 200) {
        final updatedSupplier = SupplierModel.fromJson(response.data as Map<String, dynamic>);
        logger.i('Successfully updated supplier: ${updatedSupplier.name}');
        return updatedSupplier;
      } else {
        throw Exception('Failed to update supplier');
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}', error: e);
      _handleDioException(e);
      rethrow;
    } catch (e) {
      logger.e('Exception: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      logger.i('Deleting supplier with id: $id');
      final response = await dio.delete('${AppConstants.suppliersEndpoint}/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.i('Successfully deleted supplier with id: $id');
      } else {
        throw Exception('Failed to delete supplier');
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}', error: e);
      _handleDioException(e);
      rethrow;
    } catch (e) {
      logger.e('Exception: $e', error: e);
      rethrow;
    }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      logger.e('Timeout error: ${e.message}');
    } else if (e.type == DioExceptionType.badResponse) {
      logger.e('Bad response: ${e.response?.statusCode}');
    } else if (e.type == DioExceptionType.connectionError) {
      logger.e('Connection error: ${e.message}');
    }
  }
}
