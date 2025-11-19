# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter news application using NewsAPI. The app follows a feature-based architecture with Provider for state management and a repository pattern for data access.

## Essential Commands

### Development
```bash
# Run the app
flutter run

# Run with specific device
flutter run -d <device-id>

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal

# Check available devices
flutter devices
```

### Code Generation
```bash
# Generate Hive type adapters (required after modifying @HiveType models)
flutter pub run build_runner build

# Watch mode for continuous generation during development
flutter pub run build_runner watch

# Clean and regenerate
flutter pub run build_runner build --delete-conflicting-outputs
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Format code (90 character line width configured in analysis_options.yaml)
dart format lib/

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

### Build
```bash
# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios

# Build for release
flutter build apk --release
```

## Architecture Overview

### Feature-Based Organization

The codebase is organized by features under `lib/features/`, with shared utilities in `lib/core/`:

```
lib/
├── core/                    # Shared infrastructure
│   ├── datasource/          # Data layer abstractions
│   │   ├── local_data/      # Hive (UserRepository) + SharedPreferences (PreferencesManager)
│   │   └── remote_data/     # API configuration and HTTP service
│   ├── repos/               # Cross-feature repositories (NewsRepository)
│   ├── models/              # Shared models (UserModel with Hive adapters)
│   ├── mixins/              # SafeNotify mixin (prevents disposed listener crashes)
│   ├── constants/           # App-wide constants and responsive sizes (AppSizes)
│   ├── theme/               # Material theme configuration
│   └── widgets/             # Reusable custom widgets (BookmarkButton)
└── features/                # Feature modules (self-contained)
    ├── splash/
    ├── onboarding/
    ├── auth/                # login_screen, register_screen
    ├── main/                # Bottom navigation shell
    ├── home/                # News feed with categories
    ├── search/
    ├── bookmark/            # Bookmark feature (Repository, Controller, Model, Screen)
    │   ├── models/          # BookmarkModel (Hive typeId: 1)
    │   ├── data/            # BookmarkRepository
    │   ├── bookmark_controller.dart
    │   └── bookmark_screen.dart
    ├── details/
    └── profile/
```

### Key Architectural Patterns

#### 1. Controller Pattern (State Management)
All features use **Provider** with **ChangeNotifier** controllers:

```dart
class FeatureController extends ChangeNotifier with SafeNotify {
  final SomeRepository repository;

  RequestStatusEnum status = RequestStatusEnum.loading;
  List<DataModel> data = [];
  String? errorMessage;

  FeatureController(this.repository) {
    loadData(); // Auto-load on initialization
  }

  loadData() async {
    status = RequestStatusEnum.loading;
    safeNotify();

    try {
      data = await repository.getData();
      status = RequestStatusEnum.loaded;
    } catch (e) {
      status = RequestStatusEnum.error;
      errorMessage = e.toString();
    }
    safeNotify();
  }
}
```

**Important**: Always use `safeNotify()` instead of `notifyListeners()` to prevent crashes from disposed widgets. All controllers must mix in `SafeNotify`.

#### 2. Repository Pattern
Data access is abstracted through repositories:

- **Abstract base class** defines the contract
- **Concrete implementation** handles data fetching and model transformation
- **Injected into controllers** via constructor

Example: `BaseNewsRepository` → `NewsRepository`

#### 3. Singleton Pattern
Used for data managers that should have single instances:
- `PreferencesManager` - SharedPreferences wrapper
- `UserRepository` - Hive-based user data store
- `ApiService` - HTTP client

#### 4. Data Flow
```
UI (Consumer) → Controller → Repository → ApiService/Hive
                    ↓ safeNotify()
                UI Rebuilds
```

### State Management with Provider

Two provider patterns used:

```dart
// 1. Create new instance (for initial screen)
ChangeNotifierProvider(
  create: (context) => HomeController(NewsRepository(ApiService())),
  child: HomeScreen(),
)

// 2. Pass existing instance (for navigation while preserving state)
ChangeNotifierProvider.value(
  value: Provider.of<HomeController>(context, listen: false),
  child: CategoriesScreen(),
)
```

### Data Storage Strategy

**Dual storage approach:**

1. **Hive** (structured data, type-safe):
   - User data: `UserModel` with `@HiveType` annotations
   - Located in: `core/datasource/local_data/user_repository.dart`
   - Must run code generation after model changes

2. **SharedPreferences** (simple key-value):
   - Onboarding completion flags
   - Simple app preferences
   - Located in: `core/datasource/local_data/preferences_manager.dart`

**Migration Note**: Project is actively migrating from SharedPreferences to Hive. Prefer using `UserRepository` for user-related data.

### Bookmark Feature

**Complete bookmark management system for saving articles:**

**Architecture:**
- **BookmarkModel** (`features/bookmark/models/bookmark_model.dart`): Hive model (typeId: 1) stores article data + bookmarkedAt timestamp
- **BookmarkRepository** (`features/bookmark/data/bookmark_repository.dart`): Singleton managing Hive box operations
- **BookmarkController** (`features/bookmark/bookmark_controller.dart`): State management with Provider
- **BookmarkButton** (`core/widgets/bookmark_button.dart`): Reusable widget for toggling bookmarks

**Key Features:**
- ✅ Save/remove articles across the app (Home, Search, Details)
- ✅ Animated bookmark icon with state indication
- ✅ Full-featured bookmark screen with search, delete, clear all
- ✅ Swipe-to-delete with undo functionality
- ✅ Bookmark count badge on navigation
- ✅ Pull-to-refresh support
- ✅ Sorted by most recently bookmarked

**Usage:**

```dart
// Toggle bookmark
await BookmarkRepository().toggleBookmark(article);

// Check if bookmarked
bool isBookmarked = BookmarkRepository().isBookmarked(articleUrl);

// Add bookmark button to UI
BookmarkButton(
  article: article,
  size: 24,
  activeColor: Colors.red,    // Optional
  inactiveColor: Colors.grey,  // Optional
)
```

**Data Storage:**
- Uses Hive box: `bookmarkBox`
- URL as unique key (prevents duplicates)
- Persistent across app restarts
- Offline-first architecture

### Request Status Pattern

All async operations use the `RequestStatusEnum`:

```dart
enum RequestStatusEnum { loading, loaded, error }
```

UI renders based on status:

```dart
switch (controller.status) {
  case RequestStatusEnum.loading:
    return ShimmerLoadingWidget();
  case RequestStatusEnum.error:
    return ErrorWidget(controller.errorMessage);
  case RequestStatusEnum.loaded:
    return DataWidget(controller.data);
}
```

## Responsive Design

Uses `flutter_screenutil` package with **375x832 design size** (iPhone 11 Pro).

Access sizes via `AppSizes` constants:

```dart
AppSizes.sp16  // Font sizes (16.sp)
AppSizes.h24   // Heights (24.h)
AppSizes.w16   // Widths (16.w)
AppSizes.r8    // Border radius (8.r)
AppSizes.ph16  // Padding height (16.h)
AppSizes.pw16  // Padding width (16.w)
```

Always use these constants instead of hardcoded values for consistent scaling across devices.

## Custom Widgets

Reusable widgets in `core/widgets/`:

- **CustomCachedNetworkImage**: Network image with shimmer loading and error handling
- **CustomSvgPicture**: Simplified SVG rendering with theme-aware coloring
- **CustomTextFormField**: Consistent form field styling with validation support
- **BookmarkButton**: Animated bookmark toggle with state management and user feedback

Use these instead of base Flutter widgets for consistency.

## Navigation

Uses **imperative navigation** (MaterialPageRoute):

```dart
Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
```

**Flow**: SplashScreen → checks state → OnboardingScreen/LoginScreen → MainScreen (4 bottom tabs)

## API Integration

**NewsAPI Configuration**: `core/datasource/remote_data/api_config.dart`

```dart
ApiConfig.baseUrl      // "newsapi.org"
ApiConfig.apiKey       // API key
ApiConfig.topHeadlines // Endpoint path
ApiConfig.everything   // Endpoint path
```

**Note**: API key is currently hardcoded. For production, move to environment variables.

All API calls go through `ApiService` which returns `Map<String, dynamic>`. Repositories transform JSON to models.

## Initialization Sequence

The app initialization in `main.dart` follows this critical order:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();  // 1. Screen utilities first
  await PreferencesManager().init();     // 2. SharedPreferences
  await UserRepository().init();         // 3. Hive database (User data)
  await BookmarkRepository().init();     // 4. Hive database (Bookmarks)
  runApp(const MyApp());
}
```

**Important**: Always maintain this order when adding new initializations.

## Code Generation Requirements

After modifying any `@HiveType` annotated models:

1. Run `flutter pub run build_runner build`
2. Ensure `part 'model_name.g.dart';` is present in model file
3. Verify adapter is registered in UserRepository.init()

## Common Patterns to Follow

### Adding a New Feature

1. Create feature directory under `lib/features/feature_name/`
2. Create controller extending `ChangeNotifier with SafeNotify`
3. Create screen widget consuming the controller
4. If needed, create feature-specific models in `models/` subdirectory
5. Create reusable components in `components/` subdirectory
6. Wrap screen with `ChangeNotifierProvider` when navigating

### Adding a New Model

For Hive models:
```dart
import 'package:hive_ce_flutter/adapters.dart';

part 'model_name.g.dart';

@HiveType(typeId: X) // Use next available typeId (0: UserModel, 1: BookmarkModel)
class ModelName {
  @HiveField(0)
  String? field1;

  // Include: constructor, toMap, fromMap, copyWith
}
```

Then run code generation.

### Error Handling Pattern

```dart
try {
  status = RequestStatusEnum.loading;
  safeNotify();

  final result = await repository.fetchData();

  status = RequestStatusEnum.loaded;
  errorMessage = null;
  safeNotify();
} catch (e) {
  status = RequestStatusEnum.error;
  errorMessage = e.toString();
  safeNotify();
}
```

### Safe Disposal

Always use `SafeNotify` mixin for controllers and call `safeNotify()` instead of `notifyListeners()`.

## Theme Configuration

Material 3 theme defined in `core/theme/light_theme.dart`:
- Primary color: `#C53030` (red)
- Background: `#F5F5F5` (light gray)
- Line width: 90 characters (configured in analysis_options.yaml)

Theme components customized:
- AppBar theme
- ElevatedButton theme
- InputDecoration theme
- BottomNavigationBar theme

## Important Files

- `lib/main.dart` - App entry point with initialization sequence
- `lib/core/datasource/remote_data/api_config.dart` - API configuration
- `lib/core/constants/constants.dart` - App-wide constants (Hive box names, keys)
- `lib/core/constants/app_sizes.dart` - Responsive size utilities
- `lib/core/mixins/safe_notify_mixin.dart` - Critical for safe state updates
- `lib/core/enums/request_status_enum.dart` - Standard status handling
- `lib/core/widgets/bookmark_button.dart` - Reusable bookmark toggle widget
- `lib/features/bookmark/data/bookmark_repository.dart` - Bookmark data management
- `lib/features/bookmark/bookmark_controller.dart` - Bookmark state management
- `analysis_options.yaml` - Linting rules and formatting config
- `pubspec.yaml` - Dependencies and asset configuration

## Dependencies Overview

**Key packages:**
- `provider` - State management
- `hive_ce_flutter` + `hive_ce_generator` - Local database
- `shared_preferences` - Simple key-value storage
- `http` - Network requests
- `cached_network_image` - Image caching
- `flutter_screenutil` - Responsive sizing
- `shimmer` - Loading states
- `image_picker` - Profile image selection
- `country_picker` - Country selection

## Project Context

This is a course project for "Mastering Flutter from Zero to Hero" by Usama Elgendy. The codebase demonstrates Flutter best practices including clean architecture, repository pattern, and proper state management for educational purposes.