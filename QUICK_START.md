# 🚀 Quick Start Guide

Get the Supplier Directory app running in 5 minutes!

## Prerequisites
- Flutter 3.0+ installed
- An IDE (VS Code or Android Studio)
- Android/iOS development environment set up

## 5-Minute Setup

### Step 1: Navigate to Project
```bash
cd "Mobile App Individual Project 1"
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

This will download and install all required packages (takes 1-2 minutes on first run).

### Step 3: Run the App
```bash
flutter run
```

The app will build and launch on your connected device or emulator.

### Step 4: See It in Action
- **List Screen** appears with loading shimmer (first time)
- Suppliers load from API
- Try the search bar (top)
- Try status filter chips
- Tap FAB (+) to add a supplier
- Tap a supplier card to view details
- Tap Edit or Delete in details screen

### Step 5: Test CRUD Operations
1. **Create**: Tap FAB → Fill form → Save
2. **Read**: View supplier list and details
3. **Update**: Tap Edit → Modify → Update
4. **Delete**: Tap Delete → Confirm → Removed from list

---

## Key Features to Test

### ✨ UI Elements
- [x] Summary statistics cards
- [x] Search functionality
- [x] Filter by status
- [x] Loading shimmer
- [x] Error states
- [x] Empty states
- [x] Delete confirmation

### 🎯 Form Features
- [x] Real-time validation
- [x] Error messages
- [x] Category dropdown
- [x] Status dropdown
- [x] Pre-filled edit form

### 🔄 API Integration
- [x] Create suppliers via API
- [x] Fetch suppliers from API
- [x] Update suppliers via API
- [x] Delete suppliers via API
- [x] Error handling for network issues

---

## Useful Commands

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Check code quality
flutter analyze

# Format code
dart format lib/

# Clean build
flutter clean
flutter pub get
flutter run

# Run with verbose output
flutter run -v

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

---

## Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Get dependencies error?
```bash
flutter pub cache repair
flutter pub get
```

### API not connecting?
- Check internet connection
- API is at: `https://676c7834e1d2c9c1a6d4e8f1.mockapi.io/api/v1`
- Check `lib/core/constants/app_constants.dart` for base URL

### Form won't submit?
- Ensure all required fields are filled
- Check validation messages
- Try clearing and refilling fields

---

## Documentation Files

- 📖 **README.md** - Full project overview
- 🏗️ **ARCHITECTURE.md** - Architecture explanation
- ✨ **FEATURES.md** - Complete feature list
- 📋 **PROJECT_SUMMARY.md** - What's been built
- 🔧 **SETUP_GUIDE.md** - Detailed setup instructions

---

## Project Structure at a Glance

```
lib/
├── main.dart              → Entry point
├── core/                  → Constants, theme, errors, utils
├── data/                  → API, models, repositories
├── domain/                → Business logic, entities
└── presentation/          → BLoC, screens, widgets
```

## Architecture Pattern

- **Clean Architecture**: Separation of concerns
- **BLoC**: State management
- **Dio**: HTTP client
- **Either Pattern**: Error handling

---

## Next Steps

1. Explore the code structure in `lib/`
2. Read ARCHITECTURE.md for deep dive
3. Check FEATURES.md for all capabilities
4. Customize the theme in `core/theme/`
5. Update API URL in `core/constants/` if needed

---

## Need Help?

1. Check the detailed **SETUP_GUIDE.md**
2. Review **ARCHITECTURE.md** for design
3. See **FEATURES.md** for what's implemented
4. Look at **PROJECT_SUMMARY.md** for overview

---

## Success Checklist

- [ ] Flutter installed
- [ ] Project dependencies installed (`flutter pub get`)
- [ ] No errors in `flutter doctor`
- [ ] App runs without crashing
- [ ] Supplier list loads
- [ ] Search works
- [ ] Can create supplier
- [ ] Can edit supplier
- [ ] Can delete supplier

**If all checked, you're good to go! 🎉**

---

**Happy coding with Supplier Directory! 🚀**
