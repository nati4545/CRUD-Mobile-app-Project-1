# API Configuration & Integration Guide

## Current API Setup

### Public API Used: MockAPI.io
- **Base URL**: `https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1`
- **Service**: Free mock API with CRUD support
- **Format**: REST with JSON
- **Authentication**: None (public endpoint)

### Endpoints

#### 1. Get All Suppliers
```http
GET /suppliers
```

**Response (200 OK)**
```json
[
  {
    "id": "1",
    "name": "ABC Supplies",
    "contactPerson": "John Doe",
    "phone": "+1-234-567-8900",
    "email": "john@abcsupplies.com",
    "address": "123 Business St, New York, NY 10001",
    "category": "Raw Materials",
    "status": "Active",
    "notes": "Reliable supplier"
  }
]
```

#### 2. Get Supplier by ID
```http
GET /suppliers/{id}
```

**Response (200 OK)**
```json
{
  "id": "1",
  "name": "ABC Supplies",
  "contactPerson": "John Doe",
  "phone": "+1-234-567-8900",
  "email": "john@abcsupplies.com",
  "address": "123 Business St, New York, NY 10001",
  "category": "Raw Materials",
  "status": "Active",
  "notes": "Reliable supplier"
}
```

#### 3. Create Supplier
```http
POST /suppliers
Content-Type: application/json

{
  "name": "XYZ Trading",
  "contactPerson": "Jane Smith",
  "phone": "+1-987-654-3210",
  "email": "jane@xyztrading.com",
  "address": "456 Commerce Ave, Boston, MA 02101",
  "category": "Manufacturing",
  "status": "Active",
  "notes": "New partnership"
}
```

**Response (201 Created)**
```json
{
  "id": "2",
  "name": "XYZ Trading",
  "contactPerson": "Jane Smith",
  "phone": "+1-987-654-3210",
  "email": "jane@xyztrading.com",
  "address": "456 Commerce Ave, Boston, MA 02101",
  "category": "Manufacturing",
  "status": "Active",
  "notes": "New partnership"
}
```

#### 4. Update Supplier
```http
PUT /suppliers/{id}
Content-Type: application/json

{
  "id": "1",
  "name": "ABC Supplies Inc.",
  "contactPerson": "John Doe",
  "phone": "+1-234-567-8901",
  "email": "john.doe@abcsupplies.com",
  "address": "789 Industrial Blvd, New York, NY 10002",
  "category": "Raw Materials",
  "status": "Active",
  "notes": "Updated contact information"
}
```

**Response (200 OK)**
```json
{
  "id": "1",
  "name": "ABC Supplies Inc.",
  "contactPerson": "John Doe",
  "phone": "+1-234-567-8901",
  "email": "john.doe@abcsupplies.com",
  "address": "789 Industrial Blvd, New York, NY 10002",
  "category": "Raw Materials",
  "status": "Active",
  "notes": "Updated contact information"
}
```

#### 5. Delete Supplier
```http
DELETE /suppliers/{id}
```

**Response (204 No Content)** or **Response (200 OK)**

---

## API Configuration File

Location: `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Modify these for different APIs
  static const String baseUrl = 'https://your-api.com/api/v1';
  static const String suppliersEndpoint = '/suppliers';
  static const int apiTimeout = 30000; // milliseconds
}
```

---

## Switching to a Different API

### Option 1: Use Same Data Structure

If your API uses the same supplier data structure:

1. **Update base URL** in `AppConstants`:
```dart
static const String baseUrl = 'https://your-backend.com/api/v1';
```

2. **No code changes needed** - everything else stays the same

3. **Ensure your API returns**:
```json
{
  "id": "string",
  "name": "string",
  "contactPerson": "string",
  "phone": "string",
  "email": "string",
  "address": "string",
  "category": "string",
  "status": "string",
  "notes": "string (optional)"
}
```

### Option 2: Different Data Structure

If your API uses different field names:

1. **Update SupplierModel** in `lib/data/models/supplier_model.dart`:
```dart
factory SupplierModel.fromJson(Map<String, dynamic> json) {
  return SupplierModel(
    id: json['supplier_id'] as String? ?? '', // Changed
    name: json['supplier_name'] as String? ?? '', // Changed
    // ... other fields
  );
}

Map<String, dynamic> toJson() {
  return {
    'supplier_id': id, // Changed
    'supplier_name': name, // Changed
    // ... other fields
  };
}
```

2. **Update endpoints** if different:
```dart
class AppConstants {
  static const String suppliersEndpoint = '/api/suppliers'; // If different
}
```

3. **Update timeout** if needed:
```dart
static const int apiTimeout = 60000; // Longer timeout
```

---

## Testing API Integration

### Using cURL

#### Test Get All
```bash
curl -X GET "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers"
```

#### Test Create
```bash
curl -X POST "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers" \
  -H "Content-Type: application/json" \
  -d '{
    "name":"Test Supplier",
    "contactPerson":"Test Person",
    "phone":"+1-234-567-8900",
    "email":"test@example.com",
    "address":"123 Test St",
    "category":"Raw Materials",
    "status":"Active",
    "notes":"Test note"
  }'
```

### Using Postman

1. Import to Postman collection
2. Set method (GET/POST/PUT/DELETE)
3. Enter URL
4. Add headers: `Content-Type: application/json`
5. Add request body (for POST/PUT)
6. Click Send

### Using Insomnia

Similar to Postman - GUI-based API testing.

---

## Advanced Configuration

### Custom Headers

If your API requires custom headers (like authorization):

**Update `lib/data/datasources/supplier_remote_datasource.dart`**:

```dart
SupplierRemoteDataSourceImpl({required this.dio}) {
  dio.options.baseUrl = AppConstants.baseUrl;
  dio.options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
  dio.options.headers['X-Custom-Header'] = 'value';
  // ... other config
}
```

### Custom Error Handling

**Update `_handleDioException` method** in same file:

```dart
void _handleDioException(DioException e) {
  if (e.response?.statusCode == 401) {
    // Handle unauthorized - possibly redirect to login
    logger.e('Unauthorized access');
  } else if (e.response?.statusCode == 403) {
    // Handle forbidden
    logger.e('Access forbidden');
  }
  // ... other cases
}
```

### Interceptors

**Add request/response interceptors** to Dio:

```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestPath}');
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
      return handler.next(e);
    },
  ),
);
```

---

## Popular API Options

### Option 1: Firebase Realtime Database
- **Pros**: Real-time sync, authentication built-in, scalable
- **Cons**: Proprietary, learning curve
- **Setup**: Replace Dio with Firebase SDK
- **Docs**: [firebase.flutter.dev](https://firebase.flutter.dev)

### Option 2: Supabase
- **Pros**: PostgreSQL backend, open-source alternative to Firebase
- **Cons**: Smaller community
- **Setup**: Use Supabase Flutter SDK
- **Docs**: [supabase.com/docs](https://supabase.com/docs)

### Option 3: AWS Amplify
- **Pros**: Enterprise-grade, scalable
- **Cons**: Complex setup, paid tier
- **Setup**: Use Amplify SDK
- **Docs**: [docs.amplify.aws](https://docs.amplify.aws)

### Option 4: Self-Hosted REST API
- **Pros**: Full control, custom logic
- **Cons**: Maintenance required
- **Setup**: Any backend (Node, Python, Go, etc.)
- **Requirements**: Same JSON structure as above

### Option 5: Other Mock APIs
- **JSONPlaceholder**: [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com) (read-only)
- **ReqRes**: [reqres.in](https://reqres.in) (CRUD available)
- **Mockable**: [mockable.io](https://mockable.io) (free CRUD)

---

## Production Checklist

When moving to production:

- [ ] Use HTTPS endpoint (not HTTP)
- [ ] Add API authentication/authorization
- [ ] Implement request signing if needed
- [ ] Configure rate limiting on backend
- [ ] Add request logging and monitoring
- [ ] Handle API versioning
- [ ] Implement API token refresh
- [ ] Add cache strategy
- [ ] Test error scenarios
- [ ] Monitor API response times
- [ ] Set up API rate limiting
- [ ] Add request/response encryption if needed

---

## Debugging API Issues

### Enable Verbose Logging

**In main.dart**:
```dart
import 'package:logger/logger.dart';

// Already added in SupplierRemoteDataSourceImpl
// Check logs with: flutter logs
```

### Check Request Details

Add this to see request details:

```dart
dio.interceptors.add(
  LoggingInterceptor(),
);
```

### Network Debugging

```bash
# See all network calls
flutter run -v | grep "HTTP"
```

### API Validation

Test endpoint directly:
```bash
curl -v https://your-api.com/api/v1/suppliers
```

---

## Timeout Configuration

Current: **30 seconds**

To change timeout:
```dart
// In lib/core/constants/app_constants.dart
static const int apiTimeout = 60000; // milliseconds (60 seconds)
```

Update in datasource:
```dart
dio.options.connectTimeout = const Duration(milliseconds: AppConstants.apiTimeout);
dio.options.receiveTimeout = const Duration(milliseconds: AppConstants.apiTimeout);
```

---

## Monitoring & Analytics

### Add API Monitoring
```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Log request start time
      // Send to analytics
      return handler.next(options);
    },
  ),
);
```

### Response Time Tracking
```dart
final startTime = DateTime.now();
// Make request
final duration = DateTime.now().difference(startTime);
logger.i('API call took ${duration.inMilliseconds}ms');
```

---

## Offline Support (Future Enhancement)

To add offline support:

1. Add local cache data source
2. Implement cache strategy in repository
3. Use Either pattern for cache errors
4. Sync when connection returns

---

## Summary

- **Current Setup**: MockAPI.io (free, no auth needed)
- **To Change**: Update `AppConstants.baseUrl`
- **Custom Fields**: Update `SupplierModel` serialization
- **Production**: Use proper authentication and HTTPS
- **Testing**: Use cURL, Postman, or Insomnia

---

**The app is designed to work with any REST API that returns supplier data in the expected format.**
