import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplier_directory/core/theme/app_theme.dart';
import 'package:supplier_directory/data/datasources/supplier_remote_datasource.dart';
import 'package:supplier_directory/data/repositories/supplier_repository_impl.dart';
import 'package:supplier_directory/domain/usecases/supplier_usecases.dart';
import 'package:supplier_directory/presentation/bloc/supplier_bloc.dart';
import 'package:supplier_directory/presentation/screens/supplier_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Dio
    final dio = Dio();

    // Initialize Data Sources
    final remoteDataSource = SupplierRemoteDataSourceImpl(dio: dio);

    // Initialize Repository
    final supplierRepository = SupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    // Initialize Use Cases
    final getAllSuppliersUseCase = GetAllSuppliersUseCase(
      repository: supplierRepository,
    );
    final getSupplierByIdUseCase = GetSupplierByIdUseCase(
      repository: supplierRepository,
    );
    final createSupplierUseCase = CreateSupplierUseCase(
      repository: supplierRepository,
    );
    final updateSupplierUseCase = UpdateSupplierUseCase(
      repository: supplierRepository,
    );
    final deleteSupplierUseCase = DeleteSupplierUseCase(
      repository: supplierRepository,
    );

    return MaterialApp(
      title: 'Supplier Directory',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => SupplierBloc(
          getAllSuppliersUseCase: getAllSuppliersUseCase,
          getSupplierByIdUseCase: getSupplierByIdUseCase,
          createSupplierUseCase: createSupplierUseCase,
          updateSupplierUseCase: updateSupplierUseCase,
          deleteSupplierUseCase: deleteSupplierUseCase,
        ),
        child: const SupplierListScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
