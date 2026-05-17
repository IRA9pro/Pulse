# Proper Auth Flow and Bento UI Implementation

Refactor the existing codebase to provide a clean, production-ready Auth flow using Supabase and Riverpod, while completing the Bento Box inspired Home Screen.

## Proposed Changes

### Dependencies

#### [pubspec.yaml](file:///media/ira9code/#Storage/Codes/Flutter-Projects/Pulse/pubspec.yaml)
- Move `flutter_riverpod` from `dev_dependencies` to `dependencies`.

---

### Core Services

#### [auth_service.dart](file:///media/ira9code/#Storage/Codes/Flutter-Projects/Pulse/lib/core/services/auth_service.dart)
- Rename `AuthRepository` to `AuthService`.
- Use `Supabase.instance.client` internally.
- Add `currentSession` getter.

#### [auth_provider.dart](file:///media/ira9code/#Storage/Codes/Flutter-Projects/Pulse/lib/core/services/auth_provider.dart)
- Update to use the refactored `AuthService`.
- Use `ref.watch` for the stream provider.

---

### UI Components

#### [home_screen.dart](file:///media/ira9code/#Storage/Codes/Flutter-Projects/Pulse/lib/system/home/home_screen.dart)
- Add missing imports (`material.dart`, `flutter_riverpod.dart`).
- Convert to `ConsumerWidget`.
- Add logout action in `AppBar`.
- Implement `_BentoTile` widget.

#### [main.dart](file:///media/ira9code/#Storage/Codes/Flutter-Projects/Pulse/lib/main.dart)
- Import `HomeScreen`.
- Replace placeholder text with `HomeScreen()`.

## Verification Plan

### Manual Verification
- Run `flutter pub get` to update dependencies.
- Verify that `main.dart` compiles without errors.
- Check that `LoginScreen` correctly transitions to `HomeScreen` upon successful login.
- Check that logout button returns user to `LoginScreen`.
