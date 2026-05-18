
# Supplier Directory - Flutter Mobile Application

A simple CRUD Flutter mobile application for managing supplier records using clean architecture, BLoC state management, and modern UI/UX patterns.

## 🎯 Overview

Supplier Directory is a sophisticated procurement management tool designed for businesses to create, read, update, and delete supplier records with a polished, enterprise-level interface. The app integrates with a real public API and provides comprehensive CRUD functionality with robust error handling, loading states, and user feedback mechanisms.

## 👤 Author Information

Done by: Nathnael Belay

ID No: UGR/9296/16

Section: 1

## 🖼️ Screenshots

<img width="960" height="510" alt="Screenshot 2026-05-18 133636" src="https://github.com/user-attachments/assets/1706cda1-2e7a-403e-9de6-d7b780bd2ecd" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133526" src="https://github.com/user-attachments/assets/35a836c1-ea75-47b0-9170-6a26a68b38b1" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133501" src="https://github.com/user-attachments/assets/02fdff96-7549-4d89-ae94-4897919a1e91" />
<img width="778" height="490" alt="Screenshot 2026-05-18 133420" src="https://github.com/user-attachments/assets/0f0c4e2a-988d-47a2-81a7-9cb55bb1907d" />
<img width="960" height="510" alt="Screenshot 2026-05-18 134054" src="https://github.com/user-attachments/assets/241a3425-1d6f-400e-b6d3-1192410cd965" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133955" src="https://github.com/user-attachments/assets/280996c6-1d9d-4239-8a1e-a21b8c296ec0" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133900" src="https://github.com/user-attachments/assets/f9ca930b-90be-4a8b-a997-be3c8ac61f27" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133841" src="https://github.com/user-attachments/assets/e10a46ca-3c90-4705-8d6a-dcc384e03fd4" />
<img width="960" height="510" alt="Screenshot 2026-05-18 133823" src="https://github.com/user-attachments/assets/865abef6-5252-4776-a082-bd0bbe722a19" />


## ✨ Key Features

### Core Functionality
- **Full CRUD Operations**: Create, read, update, and delete supplier records
- **Real API Integration**: Uses MockAPI.io for genuine backend communication
- **Advanced Search**: Filter suppliers by name, contact person, email, or category
- **Status Filtering**: Filter by Active/Inactive status
- **Summary Dashboard**: Real-time statistics on total, active, and inactive suppliers

### UI/UX Highlights
- **Professional Design**: Enterprise-style interface with blue/green color scheme
- **Loading States**: Skeleton shimmer loaders for a polished experience
- **Empty States**: Friendly, actionable messages when no data is available
- **Error Handling**: Clear error messages with retry functionality
- **Delete Confirmation**: Safety dialog before destructive actions
- **Responsive Layout**: Mobile-optimized UI with proper spacing and typography
- **Form Validation**: Real-time validation with helpful error messages

### Business Features
- **Supplier Categorization**: Pre-defined categories (Raw Materials, Manufacturing, Electronics, etc.)
- **Contact Management**: Store contact person, phone, email, and address
- **Status Management**: Mark suppliers as Active or Inactive
- **Notes Field**: Add custom remarks for each supplier
- **Detailed View**: Organized supplier information with grouped sections

## 🏗️ Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                          # Application core layer
│   ├── constants/
│   │   └── app_constants.dart    # App configuration & constants
│   ├── errors/
│   │   └── failures.dart          # Error handling & failure types
│   ├── theme/
│   │   └── app_theme.dart         # Material theme configuration
│   └── utils/
│       └── validation_utils.dart   # Form validation utilities
│
├── data/                          # Data layer
│   ├── datasources/
│   │   └── supplier_remote_datasource.dart   # API communication
│   ├── models/
│   │   └── supplier_model.dart    # Data models with JSON serialization
│   └── repositories/
│       └── supplier_repository_impl.dart     # Repository implementation
│
├── domain/                        # Business logic layer
│   ├── entities/
│   │   └── supplier_entity.dart   # Business entities
│   ├── repositories/
│   │   └── supplier_repository.dart         # Repository abstract
│   └── usecases/
│       └── supplier_usecases.dart           # Use case implementations
│
├── presentation/                  # UI layer
│   ├── bloc/
│   │   ├── supplier_bloc.dart     # Business logic component
│   │   ├── supplier_event.dart    # BLoC events
│   │   └── supplier_state.dart    # BLoC states
│   ├── screens/
│   │   ├── supplier_list_screen.dart        # Main list view
│   │   ├── supplier_details_screen.dart     # Detail view
│   │   └── add_supplier_screen.dart         # Add/edit form
│   └── widgets/
│       ├── loading_widgets.dart    # Loading indicators & shimmer
│       ├── empty_state_widgets.dart         # Empty state UI
│       ├── error_state_widgets.dart         # Error state UI
│       ├── delete_confirmation_dialog.dart  # Confirmation dialog
│       └── supplier_widgets.dart            # Reusable components
│
└── main.dart                      # Application entry point & DI setup
```

## 🧱 State Management

The app uses **BLoC (Business Logic Component)** pattern for state management:

### Events
- `FetchSuppliersEvent`: Load all suppliers
- `GetSupplierByIdEvent`: Load single supplier details
- `CreateSupplierEvent`: Add new supplier
- `UpdateSupplierEvent`: Modify existing supplier
- `DeleteSupplierEvent`: Remove supplier
- `SearchSuppliersEvent`: Search suppliers by query
- `FilterSuppliersByStatusEvent`: Filter by status

### States
- **List States**: `SupplierListLoading`, `SupplierListLoaded`, `SupplierListEmpty`, `SupplierListError`
- **Detail States**: `SupplierDetailLoading`, `SupplierDetailLoaded`, `SupplierDetailError`
- **Operation States**: `SupplierCreating/Created/Error`, `SupplierUpdating/Updated/Error`, `SupplierDeleting/Deleted/Error`
- **Filter States**: `SupplierSearched`, `SupplierFiltered`

## 🌐 API Integration

### Backend
- **Service**: MockAPI.io
- **Base URL**: `https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1`
- **Endpoint**: `/suppliers`

### Data Model
```json
{
  "id": "1",
  "name": "Supplier Name",
  "contactPerson": "John Doe",
  "phone": "+1-234-567-8900",
  "email": "john@supplier.com",
  "address": "123 Business St, City, Country",
  "category": "Raw Materials",
  "status": "Active",
  "notes": "Optional notes"
}
```

### Network Configuration
- **Timeout**: 30 seconds
- **HTTP Client**: Dio with error interceptor
- **Error Handling**: Comprehensive DioException handling

## 🎨 UI Components

### 4 Main Screens
1. **Supplier List Screen** - Home screen with all suppliers, search, filter, and summary cards
2. **Supplier Details Screen** - Full supplier information with action buttons
3. **Add Supplier Screen** - Form for creating new suppliers
4. **Edit Supplier Screen** - Form for updating existing suppliers (reuses Add form)

### 4 Supporting States
1. **Loading State** - Skeleton shimmer placeholders
2. **Empty State** - Friendly message with call-to-action
3. **Error State** - Clear error display with retry button
4. **Delete Confirmation** - Modal confirmation dialog

### Design System
- **Primary Color**: `#2563EB` (Blue)
- **Accent Color**: `#10B981` (Green)
- **Danger Color**: `#EF4444` (Red)
- **Background**: `#F8FAFC` (Light Blue-Gray)
- **Typography**: Poppins font family
- **Border Radius**: 12dp default, 16dp large
- **Component**: Rounded cards with subtle shadows

## 📦 Dependencies

```yaml
flutter_bloc: ^8.1.3          # State management
dio: ^5.3.1                   # HTTP client
equatable: ^2.0.5             # Value equality
dartz: ^0.10.1                # Functional programming (Either/Result)
google_fonts: ^6.1.0          # Custom typography
logger: ^2.1.0                # Logging utility
shared_preferences: ^2.2.2    # Local storage (for future features)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- iOS/Android development environment

### Installation

1. **Clone/Copy the project**
```bash
cd supplier_directory
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the application**
```bash
flutter run
```

### Configuration

The API base URL can be configured in `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1';
```

To use a different API:
1. Update the `baseUrl` in `AppConstants`
2. Ensure your API supports the same endpoints and data structure
3. Modify `SupplierModel` if the data structure differs

## 📋 Form Validation

### Implemented Validators
- **Email**: RFC-compliant email validation
- **Phone**: Accepts various phone formats (7+ digits with optional +, -, spaces, parentheses)
- **Required Fields**: All main fields required except notes
- **Address**: Minimum 5 characters
- **Category & Status**: Dropdown selection required

### Validation Utilities
Located in `lib/core/utils/validation_utils.dart` with reusable validation functions.

## 🔒 Error Handling

### Failure Types
- `NetworkFailure`: Connection/timeout issues
- `ServerFailure`: Server-side errors (5xx)
- `ValidationFailure`: Invalid data (400)
- `NotFoundFailure`: Resource not found (404)
- `CacheFailure`: Local storage issues
- `UnknownFailure`: Unexpected errors

### Error Recovery
All error states include retry functionality to gracefully recover from failures.

## 🎯 Screens Breakdown

### Supplier List Screen
- Summary statistics cards (Total, Active, Inactive)
- Search bar with real-time filtering
- Status filter chips
- Supplier cards with quick actions
- FAB for adding new supplier
- Pull-to-refresh capability

### Supplier Details Screen
- Prominent supplier name and status badge
- Grouped information sections (Contact, Business, Notes)
- Edit and Delete action buttons
- Detailed icon-labeled information rows

### Add/Edit Supplier Form
- 8 form fields (name, contact, phone, email, address, category, status, notes)
- Real-time validation with inline error messages
- Dropdown selectors for category and status
- Save/Update button with loading state
- Scrollable layout for mobile devices

## 📱 Responsive Design

- Optimized for all screen sizes
- Proper padding and spacing
- Scrollable forms and lists
- Touch-friendly buttons and interactions
- Adaptive layouts

## 🧪 Testing the App

### Sample Data Flow
1. Open the app - loads all suppliers from API
2. Use search to filter suppliers
3. Use status chips to filter
4. Tap a supplier card to view details
5. Edit supplier information
6. Create a new supplier
7. Delete a supplier with confirmation

### Network Testing
- Offline mode: App shows appropriate error messages
- Timeout: Handled with user-friendly error state
- Server errors: Clear error messages with retry option

## 🔄 Future Enhancements

Potential improvements for production deployment:
- Local caching with offline support
- Advanced filtering and sorting
- Supplier import/export (CSV, Excel)
- Bulk operations
- Image/attachment support
- Supplier ratings and reviews
- Order history integration
- Real-time notifications
- Analytics dashboard
- Multi-language support

## 👨‍💼 Architecture Principles

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Injection**: Dependencies passed through constructors
3. **Testability**: Decoupled components for easy unit testing
4. **Scalability**: Clean structure allows easy addition of features
5. **Maintainability**: Clear code organization and consistent patterns
6. **Error Handling**: Comprehensive error management at all layers
7. **User Experience**: Professional UI with proper feedback mechanisms

---

**Built with ❤️ using Flutter, BLoC, and Clean Architecture**
