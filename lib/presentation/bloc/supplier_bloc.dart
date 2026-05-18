import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplier_directory/domain/entities/supplier_entity.dart';
import 'package:supplier_directory/domain/usecases/supplier_usecases.dart';
import 'package:supplier_directory/presentation/bloc/supplier_event.dart';
import 'package:supplier_directory/presentation/bloc/supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final GetAllSuppliersUseCase getAllSuppliersUseCase;
  final GetSupplierByIdUseCase getSupplierByIdUseCase;
  final CreateSupplierUseCase createSupplierUseCase;
  final UpdateSupplierUseCase updateSupplierUseCase;
  final DeleteSupplierUseCase deleteSupplierUseCase;

  List<SupplierEntity> _allSuppliers = [];

  SupplierBloc({
    required this.getAllSuppliersUseCase,
    required this.getSupplierByIdUseCase,
    required this.createSupplierUseCase,
    required this.updateSupplierUseCase,
    required this.deleteSupplierUseCase,
  }) : super(const SupplierInitial()) {
    on<FetchSuppliersEvent>(_onFetchSuppliers);
    on<GetSupplierByIdEvent>(_onGetSupplierById);
    on<CreateSupplierEvent>(_onCreateSupplier);
    on<UpdateSupplierEvent>(_onUpdateSupplier);
    on<DeleteSupplierEvent>(_onDeleteSupplier);
    on<SearchSuppliersEvent>(_onSearchSuppliers);
    on<FilterSuppliersByStatusEvent>(_onFilterSuppliers);
  }

  Future<void> _onFetchSuppliers(
    FetchSuppliersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierListLoading());

    final result = await getAllSuppliersUseCase();

    result.fold(
      (failure) {
        emit(SupplierListError(failure: failure));
      },
      (suppliers) {
        _allSuppliers = suppliers;
        if (suppliers.isEmpty) {
          emit(const SupplierListEmpty());
        } else {
          final activeCount = suppliers.where((s) => s.status == 'Active').length;
          final inactiveCount = suppliers.where((s) => s.status == 'Inactive').length;
          emit(SupplierListLoaded(
            suppliers: suppliers,
            totalSuppliers: suppliers.length,
            activeSuppliers: activeCount,
            inactiveSuppliers: inactiveCount,
          ));
        }
      },
    );
  }

  Future<void> _onGetSupplierById(
    GetSupplierByIdEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierDetailLoading());

    final result = await getSupplierByIdUseCase(event.id);

    result.fold(
      (failure) {
        SupplierEntity? existingSupplier;
        try {
          existingSupplier = _allSuppliers.firstWhere((item) => item.id == event.id);
        } catch (_) {
          existingSupplier = null;
        }
        if (existingSupplier != null) {
          emit(SupplierDetailLoaded(supplier: existingSupplier));
        } else {
          emit(SupplierDetailError(failure: failure));
        }
      },
      (supplier) {
        emit(SupplierDetailLoaded(supplier: supplier));
      },
    );
  }

  Future<void> _onCreateSupplier(
    CreateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierCreating());

    final result = await createSupplierUseCase(event.supplier);

    result.fold(
      (failure) {
        emit(SupplierCreationError(failure: failure));
      },
      (supplier) {
        _allSuppliers.add(supplier);
        emit(SupplierCreated(supplier: supplier));
        if (_allSuppliers.isEmpty) {
          emit(const SupplierListEmpty());
        } else {
          final activeCount = _allSuppliers.where((s) => s.status == 'Active').length;
          final inactiveCount = _allSuppliers.where((s) => s.status == 'Inactive').length;
          emit(SupplierListLoaded(
            suppliers: List<SupplierEntity>.from(_allSuppliers),
            totalSuppliers: _allSuppliers.length,
            activeSuppliers: activeCount,
            inactiveSuppliers: inactiveCount,
          ));
        }
      },
    );
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierUpdating());

    final result = await updateSupplierUseCase(event.id, event.supplier);

    result.fold(
      (failure) {
        emit(SupplierUpdationError(failure: failure));
      },
      (supplier) {
        final index = _allSuppliers.indexWhere((s) => s.id == event.id);
        if (index != -1) {
          _allSuppliers[index] = supplier;
        }
        emit(SupplierUpdated(supplier: supplier));
        if (_allSuppliers.isEmpty) {
          emit(const SupplierListEmpty());
        } else {
          final activeCount = _allSuppliers.where((s) => s.status == 'Active').length;
          final inactiveCount = _allSuppliers.where((s) => s.status == 'Inactive').length;
          emit(SupplierListLoaded(
            suppliers: List<SupplierEntity>.from(_allSuppliers),
            totalSuppliers: _allSuppliers.length,
            activeSuppliers: activeCount,
            inactiveSuppliers: inactiveCount,
          ));
        }
      },
    );
  }

  Future<void> _onDeleteSupplier(
    DeleteSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierDeleting());

    final result = await deleteSupplierUseCase(event.id);

    result.fold(
      (failure) {
        emit(SupplierDeletionError(failure: failure));
      },
      (_) {
        _allSuppliers.removeWhere((s) => s.id == event.id);
        emit(const SupplierDeleted());
        if (_allSuppliers.isEmpty) {
          emit(const SupplierListEmpty());
        } else {
          final activeCount = _allSuppliers.where((s) => s.status == 'Active').length;
          final inactiveCount = _allSuppliers.where((s) => s.status == 'Inactive').length;
          emit(SupplierListLoaded(
            suppliers: List<SupplierEntity>.from(_allSuppliers),
            totalSuppliers: _allSuppliers.length,
            activeSuppliers: activeCount,
            inactiveSuppliers: inactiveCount,
          ));
        }
      },
    );
  }

  Future<void> _onSearchSuppliers(
    SearchSuppliersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const FetchSuppliersEvent());
      return;
    }

    final filtered = _allSuppliers
        .where((supplier) =>
            supplier.name.toLowerCase().contains(event.query.toLowerCase()) ||
            supplier.contactPerson.toLowerCase().contains(event.query.toLowerCase()) ||
            supplier.email.toLowerCase().contains(event.query.toLowerCase()) ||
            supplier.category.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    if (filtered.isEmpty) {
      emit(const SupplierListEmpty());
    } else {
      emit(SupplierSearched(suppliers: filtered));
    }
  }

  Future<void> _onFilterSuppliers(
    FilterSuppliersByStatusEvent event,
    Emitter<SupplierState> emit,
  ) async {
    if (event.status.isEmpty) {
      add(const FetchSuppliersEvent());
      return;
    }

    final filtered = _allSuppliers
        .where((supplier) => supplier.status == event.status)
        .toList();

    if (filtered.isEmpty) {
      emit(const SupplierListEmpty());
    } else {
      emit(SupplierFiltered(suppliers: filtered));
    }
  }
}
