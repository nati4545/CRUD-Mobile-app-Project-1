# Architecture Documentation - Supplier Directory

## 🏛️ Clean Architecture Overview

The Supplier Directory app follows **Clean Architecture** principles, ensuring separation of concerns, testability, maintainability, and scalability. The architecture is divided into three main layers:

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │  ← UI & User Interaction
│  (Screens, Widgets, BLoC)              │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         DOMAIN LAYER                    │  ← Business Logic
│  (Entities, Use Cases, Repositories)   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         DATA LAYER                      │  ← Data Access
│  (Models, Data Sources, Repositories) │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         CORE LAYER                      │  ← Shared Resources
│  (Theme, Constants, Errors, Utils)    │
└─────────────────────────────────────────┘
```

## 📊 Detailed Layer Breakdown

### 1. PRESENTATION LAYER (`lib/presentation/`)

Responsible for displaying UI and handling user interactions.

#### Components:

**BLoC (Business Logic Component)**
- `supplier_bloc.dart`: Main business logic
- `supplier_event.dart`: User actions and events
- `supplier_state.dart`: Application states
- Manages state transitions and side effects
- Decouples UI from business logic

**Screens**
- `supplier_list_screen.dart`: Main supplier list with search and filter
- `supplier_details_screen.dart`: Individual supplier information
- `add_supplier_screen.dart`: Form for creating/editing suppliers

**Widgets**
- `loading_widgets.dart`: Skeleton loaders and progress indicators
- `empty_state_widgets.dart`: No data scenarios
- `error_state_widgets.dart`: Error display and retry UI
- `delete_confirmation_dialog.dart`: Delete safety dialog
- `supplier_widgets.dart`: Reusable components (cards, badges, summary)

#### Key Responsibilities:
- Render UI components
- Handle user input and navigation
- Listen to BLoC state changes
- Show appropriate UI states (loading, empty, error, success)
- Display user feedback (toasts, snackbars)

#### Dependencies:
- BLoC for state management
- Flutter widgets
- Domain layer entities

---

### 2. DOMAIN LAYER (`lib/domain/`)

Pure business logic, completely independent of implementation details.

#### Components:

**Entities**
- `supplier_entity.dart`: Core business object
- Represents supplier domain concept
- No database or API specifics
- Immutable value objects using Equatable

**Repositories (Abstract)**
- `supplier_repository.dart`: Abstract interface
- Defines operations (CRUD)
- Uses Either<Failure, T> for error handling
- No implementation details

**Use Cases**
- `supplier_usecases.dart`: Business operations
  - `GetAllSuppliersUseCase`
  - `GetSupplierByIdUseCase`
  - `CreateSupplierUseCase`
  - `UpdateSupplierUseCase`
  - `DeleteSupplierUseCase`
- Single responsibility principle
- Takes repository as dependency

#### Key Responsibilities:
- Define business logic
- Specify domain objects
- Abstract repository contracts
- No platform-specific code
- No external dependencies

#### Dependencies:
- Only dartz (Either/Result pattern)
- Equatable (value equality)
- Core layer

---

### 3. DATA LAYER (`lib/data/`)

Implements domain contracts and handles data access.

#### Components:

**Models**
- `supplier_model.dart`: JSON-serializable data class
- Extends/maps domain entity
- Handles JSON conversion (fromJson/toJson)
- `toEntity()` method converts to domain entity

**Data Sources**
- `supplier_remote_datasource.dart`: API communication
- Concrete implementation of data fetching
- Uses Dio for HTTP requests
- Handles network errors
- Logging and monitoring

**Repositories**
- `supplier_repository_impl.dart`: Implements domain repository
- Bridges data sources and domain
- Error mapping (Network, Server, Validation failures)
- Data transformation

#### Data Flow:
```
API Response
    ↓
SupplierModel (JSON deserialization)
    ↓
SupplierEntity (mapping)
    ↓
Domain Layer
    ↓
Presentation Layer
```

#### Key Responsibilities:
- Fetch data from API
- Transform API responses to domain entities
- Handle network errors
- Map technical errors to domain failures
- Cache data (optional)

#### Dependencies:
- Domain layer (repository contracts, entities)
- Dio (HTTP client)
- Core layer (errors, constants)

---

### 4. CORE LAYER (`lib/core/`)

Shared utilities and configurations used across all layers.

#### Components:

**Constants**
- `app_constants.dart`: App-wide configuration
- API URLs and timeouts
- Validation rules
- Predefined lists (categories, statuses)
- UI constants

**Errors & Failures**
- `failures.dart`: Error hierarchy
- `NetworkFailure`: Connection issues
- `ServerFailure`: Server errors
- `ValidationFailure`: Invalid data
- `NotFoundFailure`: Resource not found
- `CacheFailure`: Storage issues
- `UnknownFailure`: Unexpected errors

**Theme**
- `app_theme.dart`: Material Design theme
- Color palette and typography
- Input decoration styles
- Button styles
- Reusable styling

**Utils**
- `validation_utils.dart`: Form validation
- Email, phone, address validators
- String extensions
- Reusable validation functions

#### Key Responsibilities:
- Provide shared resources
- Define error types
- Configure theming
- Validation utilities

#### Dependencies:
- Flutter, Material Design
- Google Fonts

---

## 🔄 Data Flow Example: Fetching Suppliers

### Request Flow (User Action → Display)

```
User taps "Refresh" on List Screen
         ↓
Presentation Layer
  SupplierListScreen
    └→ context.read<SupplierBloc>()
         .add(FetchSuppliersEvent())
         ↓
  SupplierBloc receives event
    └→ on<FetchSuppliersEvent>()
         ↓
Domain Layer
  SupplierBloc calls GetAllSuppliersUseCase
    └→ repository.getAllSuppliers()
         ↓
Data Layer
  SupplierRepositoryImpl
    └→ remoteDataSource.getAllSuppliers()
         ↓
  SupplierRemoteDataSourceImpl
    └→ dio.get('/suppliers')
         ↓
  API Response
    └→ [JSON Array of Suppliers]
         ↓
         Model Conversion
    └→ List<SupplierModel>
         ↓
         Entity Mapping
    └→ List<SupplierEntity>
         ↓
  Return Right(suppliers)
    └→ Either<Failure, List<SupplierEntity>>
         ↓
Domain Layer
  SupplierBloc processes result
    └→ emit(SupplierListLoaded(suppliers))
         ↓
Presentation Layer
  BlocBuilder listens to state change
    └→ Build UI with supplier list
         ↓
  User sees suppliers on screen
```

### Error Flow

```
API Request Fails
    ↓
DioException caught
    ↓
Data Layer handles exception
  └→ _handleDioException(error)
    └→ Map to appropriate Failure type
    └→ Return Left(failure)
    └→ Either<Failure, List>
         ↓
Domain Layer
  SupplierBloc receives failure
    └→ fold(failure, success)
    └→ emit(SupplierListError(failure))
         ↓
Presentation Layer
  BlocBuilder receives error state
    └→ Build error UI
    └→ Show error message
    └→ Show retry button
         ↓
User sees error with retry option
    └→ Can tap retry to refetch
```

---

## 🏷️ BLoC State Management

### Event Processing
```
Event → Bloc Logic → State Emission → UI Rebuild
```

### State Hierarchy
```
SupplierState (Abstract)
  ├── Initial states
  │   └── SupplierInitial
  │
  ├── List operations
  │   ├── SupplierListLoading
  │   ├── SupplierListLoaded
  │   ├── SupplierListEmpty
  │   └── SupplierListError
  │
  ├── Detail operations
  │   ├── SupplierDetailLoading
  │   ├── SupplierDetailLoaded
  │   └── SupplierDetailError
  │
  ├── Create operations
  │   ├── SupplierCreating
  │   ├── SupplierCreated
  │   └── SupplierCreationError
  │
  ├── Update operations
  │   ├── SupplierUpdating
  │   ├── SupplierUpdated
  │   └── SupplierUpdationError
  │
  ├── Delete operations
  │   ├── SupplierDeleting
  │   ├── SupplierDeleted
  │   └── SupplierDeletionError
  │
  └── Filter/Search operations
      ├── SupplierSearched
      └── SupplierFiltered
```

### Key Event Handlers
```
FetchSuppliersEvent
  └→ _onFetchSuppliers()
    └→ Calls GetAllSuppliersUseCase
    └→ Emits Loading → Loaded/Empty/Error

GetSupplierByIdEvent
  └→ _onGetSupplierById()
    └→ Calls GetSupplierByIdUseCase
    └→ Emits DetailLoading → DetailLoaded/Error

CreateSupplierEvent
  └→ _onCreateSupplier()
    └→ Calls CreateSupplierUseCase
    └→ Emits Creating → Created/Error
    └→ Triggers list refresh

UpdateSupplierEvent
  └→ _onUpdateSupplier()
    └→ Calls UpdateSupplierUseCase
    └→ Emits Updating → Updated/Error
    └→ Updates local list
    └→ Triggers list refresh

DeleteSupplierEvent
  └→ _onDeleteSupplier()
    └→ Calls DeleteSupplierUseCase
    └→ Emits Deleting → Deleted/Error
    └→ Removes from local list
    └→ Triggers list refresh

SearchSuppliersEvent
  └→ _onSearchSuppliers()
    └→ Filters in-memory list
    └→ Emits Searched state

FilterSuppliersByStatusEvent
  └→ _onFilterSuppliers()
    └→ Filters by status
    └→ Emits Filtered state
```

---

## 🔐 Error Handling Strategy

### Error Propagation
```
Network Error
    ↓
DioException
    ↓
Data Layer → Caught & Mapped
    ↓
NetworkFailure / ServerFailure / etc
    ↓
Domain Layer → Propagated
    ↓
Either<Failure, T>
    ↓
Presentation Layer → Handled
    ↓
Error UI with Retry
```

### Error Recovery
1. Show user-friendly error message
2. Provide retry mechanism
3. Log error for debugging
4. Allow navigation away
5. Graceful degradation

---

## 🧪 Testing Strategy

### Unit Tests (Domain Layer)
- Test use cases
- Test repository contracts
- No external dependencies

### Widget Tests (Presentation)
- Test widgets in isolation
- Mock BLoC
- Verify UI rendering

### Integration Tests
- Test complete user flows
- Mock API responses
- Verify end-to-end functionality

---

## 🚀 Scalability Considerations

### Adding New Features
1. Create entity in domain
2. Create use case
3. Implement data source
4. Implement repository
5. Create BLoC events/states
6. Build UI screens/widgets

### Adding New Data Source
1. Create new data source interface
2. Implement data source
3. Inject into repository
4. Use abstract repository pattern

### Caching Implementation
1. Add cache datasource interface
2. Implement local cache layer
3. Update repository with cache strategy
4. Use Either pattern for cache errors

### Real-time Updates
1. Add WebSocket or stream datasource
2. Create stream-based states
3. Update BLoC to handle streams
4. Emit state changes from stream

---

## 📋 Dependency Injection

The app uses constructor-based dependency injection set up in `main.dart`:

```dart
// Initialize layers bottom-up
final dio = Dio();
final remoteDataSource = SupplierRemoteDataSourceImpl(dio: dio);
final repository = SupplierRepositoryImpl(remoteDataSource: remoteDataSource);
final useCase = GetAllSuppliersUseCase(repository: repository);
final bloc = SupplierBloc(useCase: useCase);

// Provide to UI
BlocProvider(
  create: (context) => bloc,
  child: const SupplierListScreen(),
)
```

This approach:
- Makes dependencies explicit
- Enables easy testing with mocks
- Supports dependency swapping
- Improves code readability

---

## 🎯 Design Patterns Used

| Pattern | Where | Purpose |
|---------|-------|---------|
| Clean Architecture | Overall | Separation of concerns |
| Repository | Data Layer | Abstract data access |
| BLoC | Presentation | State management |
| Use Case | Domain | Business logic |
| Functional | Error Handling | Either/Result pattern |
| Factory | Data Layer | Object creation |
| Singleton | Core | Shared instances |
| Observer | BLoC | State listening |
| Strategy | Validation | Different validators |
| Builder | Widgets | Complex UI construction |

---

## 📈 Performance Considerations

1. **State Caching**: Bloc maintains supplier list in memory
2. **Search Filtering**: In-memory filtering for instant results
3. **Lazy Loading**: Load details on demand
4. **Image Caching**: Future enhancement for network images
5. **Pagination**: Future enhancement for large datasets
6. **Local Cache**: Future enhancement for offline support

---

## 🔒 Security Considerations

1. **Input Validation**: All user inputs validated
2. **HTTPS**: API uses secure connection
3. **Error Messages**: No sensitive data in errors
4. **Data Sanitization**: Input sanitization before storage
5. **Timeout Protection**: API timeouts configured
6. **Rate Limiting**: Server-side rate limiting

---

## 🎓 Learning Resources

### Clean Architecture
- "Clean Code" by Robert C. Martin
- "Clean Architecture" by Robert C. Martin
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd)

### BLoC Pattern
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Flutter BLoC Tutorial](https://www.youtube.com/c/Reso_Coder)

### Functional Programming
- [Dartz Package](https://pub.dev/packages/dartz)
- [Either/Result Pattern](https://medium.com/flutter-community/dartz-the-path-to-functional-programming-in-dart-1e92c99d4d4a)

---

**This architecture ensures a professional, maintainable, and scalable Flutter application.**
