# Setup Guide - Supplier Directory App

## 🔧 Development Environment Setup

### Prerequisites
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher (included with Flutter)
- **Android Studio** or **Xcode** (depending on target platform)
- **Visual Studio Code** or **Android Studio IDE**

### Step 1: Install Flutter

#### Windows
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\src\flutter`
3. Add to PATH: `C:\src\flutter\bin`
4. Run `flutter doctor` to verify installation

#### macOS
```bash
brew install flutter
flutter doctor
```

#### Linux
```bash
sudo apt-get install git curl
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

### Step 2: Platform-Specific Setup

#### For Android Development
1. Install Android Studio
2. Run `flutter doctor --android-licenses`
3. Accept all licenses
4. Verify with `flutter doctor -v`

#### For iOS Development (macOS only)
1. Install Xcode
2. Run `sudo xcode-select --switch /Applications/Xcode.app/xcode-select`
3. Run `pod setup` (may take several minutes)
4. Verify with `flutter doctor -v`

### Step 3: Project Setup

1. **Navigate to project directory**
```bash
cd "Mobile App Individual Project 1"
```

2. **Get dependencies**
```bash
flutter pub get
```

3. **Verify setup**
```bash
flutter doctor
```

All checks should pass with a ✓ mark.

## 🚀 Running the Application

### Android
```bash
flutter run
```

Or for a specific device:
```bash
flutter devices
flutter run -d <device_id>
```

### iOS
```bash
cd ios
pod install
cd ..
flutter run
```

### Web (optional)
```bash
flutter run -d chrome
```

## 🔗 API Configuration

### Current Configuration
- **Provider**: MockAPI.io
- **Base URL**: `https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1`
- **Endpoint**: `/suppliers`

### Testing the API

#### Create a Supplier
```bash
curl -X POST "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ABC Supplies",
    "contactPerson": "John Doe",
    "phone": "+1-234-567-8900",
    "email": "john@abcsupplies.com",
    "address": "123 Business Street, New York, NY 10001",
    "category": "Raw Materials",
    "status": "Active",
    "notes": "Reliable supplier"
  }'
```

#### Get All Suppliers
```bash
curl -X GET "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers"
```

#### Get Specific Supplier
```bash
curl -X GET "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers/1"
```

#### Update Supplier
```bash
curl -X PUT "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers/1" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "ABC Supplies Inc.",
    "contactPerson": "Jane Doe",
    "phone": "+1-234-567-8901",
    "email": "jane@abcsupplies.com",
    "address": "456 Business Avenue, New York, NY 10002",
    "category": "Manufacturing",
    "status": "Active",
    "notes": "Updated supplier info"
  }'
```

#### Delete Supplier
```bash
curl -X DELETE "https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1/suppliers/1"
```

### Using a Different API

To connect to a different API:

1. **Update `lib/core/constants/app_constants.dart`**
```dart
class AppConstants {
  static const String baseUrl = 'https://your-api.com/api/v1';
  static const String suppliersEndpoint = '/suppliers';
  // ... other constants
}
```

2. **Ensure your API returns the same data structure:**
```json
{
  "id": "unique_identifier",
  "name": "Supplier Name",
  "contactPerson": "Contact Name",
  "phone": "Phone Number",
  "email": "Email Address",
  "address": "Full Address",
  "category": "Category",
  "status": "Active|Inactive",
  "notes": "Optional Notes"
}
```

3. **If data structure differs:**
   - Modify `SupplierModel.fromJson()` in `lib/data/models/supplier_model.dart`
   - Update `SupplierModel.toJson()` to match your API
   - Adjust field mappings accordingly

## 📱 Testing the App

### Manual Testing Checklist

- [ ] **App Launch**
  - [ ] App starts without errors
  - [ ] Supplier list loads
  - [ ] Summary cards display correctly

- [ ] **List Screen**
  - [ ] All suppliers display in cards
  - [ ] Search functionality works
  - [ ] Status filter chips work
  - [ ] Refresh button works
  - [ ] FAB (Add button) opens add screen

- [ ] **Add Supplier**
  - [ ] All form fields accept input
  - [ ] Validation messages appear
  - [ ] Email validation works
  - [ ] Phone validation works
  - [ ] Dropdowns work
  - [ ] Save creates new supplier
  - [ ] Success message appears
  - [ ] Returns to list after save

- [ ] **Supplier Details**
  - [ ] All supplier information displays
  - [ ] Edit button works
  - [ ] Delete button shows confirmation
  - [ ] Confirmation dialog appears

- [ ] **Edit Supplier**
  - [ ] Form pre-fills with existing data
  - [ ] Update changes supplier
  - [ ] Success message appears
  - [ ] Returns to list after update

- [ ] **Delete Supplier**
  - [ ] Confirmation dialog shows supplier name
  - [ ] Warning message appears
  - [ ] Cancel dismisses dialog
  - [ ] Delete removes supplier
  - [ ] Success message appears
  - [ ] List updates after delete

- [ ] **Error Handling**
  - [ ] Network error shows proper error state
  - [ ] Retry button works
  - [ ] Server errors show appropriate message
  - [ ] Timeout shows connection error

- [ ] **Loading States**
  - [ ] Shimmer loaders show while loading
  - [ ] Loading indicator shows for forms
  - [ ] Empty state shows when no suppliers

## 🐛 Troubleshooting

### Common Issues

**"flutter: command not found"**
- Add Flutter to PATH
- Restart terminal/IDE
- Verify with `flutter --version`

**"error: unable to find git"**
- Install Git from [git-scm.com](https://git-scm.com)

**Build cache issues**
- Run `flutter clean`
- Run `flutter pub get`
- Run `flutter run`

**iOS build issues**
- Run `cd ios && pod install && cd ..`
- Clean Xcode build: `flutter clean`

**Android build issues**
- Update Android SDK: Open Android Studio → SDK Manager
- Clean gradle: `./gradlew clean`
- Run `flutter clean && flutter pub get`

**API Connection Issues**
- Check internet connection
- Verify API URL in `app_constants.dart`
- Test API with curl/Postman
- Check firewall settings

**Hot reload not working**
- Restart the app
- Use `flutter run -v` for debugging
- Check for syntax errors

## 🔍 Debugging

### Enable Verbose Output
```bash
flutter run -v
```

### Check Device Logs
```bash
flutter logs
```

### Debug with DevTools
```bash
flutter pub global activate devtools
devtools
```

### Hot Reload
- Press `r` in terminal after saving changes
- Changes appear instantly in app

### Hot Restart
- Press `R` in terminal to full app restart
- Resets app state

## 📊 App Structure Overview

```
lib/
├── main.dart                    # Entry point with DI setup
├── core/
│   ├── constants/               # App constants
│   ├── errors/                  # Error handling
│   ├── theme/                   # Material design theme
│   └── utils/                   # Utility functions
├── data/
│   ├── datasources/             # API communication
│   ├── models/                  # Data models
│   └── repositories/            # Repository pattern
├── domain/
│   ├── entities/                # Business entities
│   ├── repositories/            # Abstract repositories
│   └── usecases/                # Business logic
└── presentation/
    ├── bloc/                    # BLoC files
    ├── screens/                 # App screens
    └── widgets/                 # Reusable widgets
```

## 📝 Key Commands

```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean

# Run app
flutter run

# Run in release mode
flutter run --release

# Build APK (Android)
flutter build apk

# Build IPA (iOS)
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# View git changes
git diff
```

## ✅ Verification Checklist

- [ ] Flutter SDK installed and in PATH
- [ ] Android/iOS development environment configured
- [ ] Project dependencies installed (`flutter pub get`)
- [ ] No errors in `flutter doctor`
- [ ] API is accessible
- [ ] App runs without errors
- [ ] All screens load properly
- [ ] Forms submit successfully
- [ ] Error states display correctly
- [ ] Search and filter work as expected

## 🆘 Support

For issues or questions:
1. Check Flutter documentation: [flutter.dev](https://flutter.dev)
2. Review error messages in `flutter run -v` output
3. Check API responses with curl or Postman
4. Verify all dependencies are installed: `flutter pub get`

---

**Happy coding! 🚀**
