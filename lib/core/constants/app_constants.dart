class AppConstants {
  static const String appName = 'Supplier Directory';
  
  // API Configuration
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String suppliersEndpoint = '/users';
  static const int apiTimeout = 30000; // milliseconds

  // Validation
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhone = 'Please enter a valid phone number';
  
  // Messages
  static const String deleteConfirmationMessage = 
      'This action cannot be undone. Are you sure you want to delete this supplier?';
  static const String noSuppliersMessage = 'No suppliers available';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  
  // Durations
  static const Duration debounce = Duration(milliseconds: 500);
}

class SupplierCategories {
  static const List<String> categories = [
    'Raw Materials',
    'Manufacturing',
    'Electronics',
    'Chemicals',
    'Textiles',
    'Logistics',
    'Packaging',
    'Services',
    'Other'
  ];
}

class SupplierStatus {
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  
  static const List<String> statuses = [active, inactive];
}
