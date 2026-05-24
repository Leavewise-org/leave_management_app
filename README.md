# Leave Management System

**Flutter · Firebase · Riverpod · Clean Architecture · Multi-Tenant**

---

## Project Overview

A full-featured, multi-tenant leave management platform built with Flutter, Firebase, and Riverpod following Clean Architecture principles. Supports multiple schools (tenants) with complete data isolation enforced at the database level via Firestore Security Rules. Each school has its own employees, managers, and leave configuration. A super-admin role provides a cross-school platform dashboard.

Supports employee and manager workflows including leave application, approval, team calendar, and reporting — plus school onboarding and role-based data isolation.

---

## Tech Stack

| Category | Technology | Purpose |
|---|---|---|
| Frontend | Flutter 3.x | Cross-platform UI (Android, iOS, Web) |
| Backend / DB | Firebase | Firestore, Auth, Storage, Security Rules |
| State management | Riverpod 2.x | Async state, providers, dependency injection |
| Code generation | freezed + json_serializable | Immutable models, JSON serialization |
| Routing | go_router | Declarative navigation with guards |
| DI / Service Locator | get_it | Dependency injection container |
| Local storage | flutter_secure_storage | Token caching, offline prefs |
| HTTP / API | firebase_core, cloud_firestore, firebase_auth | Firebase Flutter SDKs |
| UI components | flutter_screenutil | Responsive sizing |
| Date handling | table_calendar | Leave calendar widget |

| Linting | flutter_lints | Code quality |
| Testing | mocktail + flutter_test | Unit and widget tests |

---

## Multi-Tenant Architecture

### Core Principle

Every Firestore document inside subcollections carries a `schoolId` reference or is nested under a `schools` collection. Every Security Rule checks both `schoolId` and the user's role from their user document or custom claims. A manager at Ananda College cannot read, write, or approve leaves belonging to Royal College — enforced at the database level, not just the application layer.

### Roles

| Role | Scope |
|---|---|
| `employee` | Own leaves within their school |
| `manager` | Team leaves within their school |
| `school_admin` | All data within their school |
| `super_admin` | Cross-school platform dashboard |

---

## Prerequisites

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio or VS Code with Flutter extension
- Firebase project (at console.firebase.google.com)
- Git

---

## Firebase Setup

### Step 1 — Create a Firebase Project

- Go to [console.firebase.google.com](https://console.firebase.google.com) and create a new project.
- Enable **Authentication** (Email/Password provider).
- Enable **Firestore Database** (Start in production mode).
- Enable **Firebase Storage**.
- Register your Android, iOS, and Web apps to get the respective configuration files (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`).

---

### Step 2 — Firestore Data Structure

We use a root-level collections structure to keep querying simple and scalable:

- `/schools/{schoolId}`
- `/profiles/{userId}` (Extends Firebase Auth User)
- `/departments/{departmentId}`
- `/leave_balances/{balanceId}`
- `/leave_requests/{requestId}`
- `/leave_type_configs/{configId}`

---

### Step 3 — Configure Firestore Security Rules

To enforce multi-tenancy and role-based access, you must deploy Firestore security rules. If you skip this, Firebase will block all reads and writes by default.

**How to deploy:**
1. Ensure your `.firebaserc` file points to your active project (e.g., `{"projects": {"default": "leave-management-system-ed5eb"}}`).
2. Run these commands in your terminal:

```bash
firebase login
firebase deploy --only firestore:rules
```

Here are the rules that should be in your `firestore.rules` file:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ── HELPER FUNCTIONS ──────────────────────
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserProfile() {
      return get(/databases/$(database)/documents/profiles/$(request.auth.uid)).data;
    }
    
    function isMySchool(schoolId) {
      return getUserProfile().schoolId == schoolId;
    }
    
    function getMyRole() {
      return getUserProfile().role;
    }
    
    // ── PROFILES ──────────────────────────────
    match /profiles/{userId} {
      allow read: if isAuthenticated() && (
        request.auth.uid == userId ||
        getMyRole() == 'super_admin' ||
        (isMySchool(resource.data.schoolId) && getMyRole() in ['manager', 'school_admin'])
      );
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }

    // ── LEAVE REQUESTS ────────────────────────
    match /leave_requests/{requestId} {
      allow read: if isAuthenticated() && (
        getMyRole() == 'super_admin' ||
        (isMySchool(resource.data.schoolId) && getMyRole() in ['manager', 'school_admin']) ||
        (isMySchool(resource.data.schoolId) && resource.data.userId == request.auth.uid)
      );
      
      allow create: if isAuthenticated() && 
        isMySchool(request.resource.data.schoolId) && 
        request.resource.data.userId == request.auth.uid;
        
      allow update: if isAuthenticated() && 
        isMySchool(resource.data.schoolId) && 
        getMyRole() in ['manager', 'school_admin'];
    }

    // ── LEAVE BALANCES ────────────────────────
    match /leave_balances/{balanceId} {
      allow read: if isAuthenticated() && (
        getMyRole() == 'super_admin' ||
        (isMySchool(resource.data.schoolId) && getMyRole() in ['manager', 'school_admin']) ||
        (isMySchool(resource.data.schoolId) && resource.data.userId == request.auth.uid)
      );
    }

    // ── LEAVE TYPE CONFIGS ────────────────────
    match /leave_type_configs/{configId} {
      allow read: if isAuthenticated() && isMySchool(resource.data.schoolId);
      allow write: if isAuthenticated() && 
        isMySchool(resource.data.schoolId) && 
        getMyRole() in ['school_admin', 'super_admin'];
    }

    // ── SCHOOLS ───────────────────────────────
    match /schools/{schoolId} {
      allow read: if isAuthenticated() && (
        getMyRole() == 'super_admin' || isMySchool(schoolId)
      );
      allow write: if isAuthenticated() && getMyRole() == 'super_admin';
    }
  }
}
```

---


## Flutter Project Setup

### Step 1 — Clone and Install

```bash
git clone https://github.com/your-org/leave-management-app.git
cd leave-management-app
flutter pub get
```

### Step 2 — Firebase Configuration

Use the FlutterFire CLI to configure the project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This will generate `lib/firebase_options.dart`.

Initialize Firebase in `main.dart`:

```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

### Step 3 — Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4 — Run the App

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

---

## Folder Structure

Clean Architecture with an added `school` feature and `super_admin` panel.

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_text_styles.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_guards.dart        ← guards check role + schoolId
│   ├── di/
│   │   └── injection_container.dart
│   └── utils/
│       ├── date_utils.dart
│       └── validators.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_usecase.dart
│   │   │       └── sign_out_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   │
│   ├── school/                        ← NEW: school/tenant feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── school_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── school_model.dart
│   │   │   └── repositories/
│   │   │       └── school_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── school_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── school_repository.dart
│   │   │   └── usecases/
│   │   │       ├── onboard_school_usecase.dart
│   │   │       └── get_school_config_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── school_provider.dart
│   │       ├── pages/
│   │       │   ├── school_onboarding_page.dart
│   │       │   └── school_settings_page.dart
│   │       └── widgets/
│   │           └── school_header.dart
│   │
│   ├── leave/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── leave_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── leave_request_model.dart
│   │   │   │   └── leave_balance_model.dart
│   │   │   └── repositories/
│   │   │       └── leave_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── leave_request_entity.dart
│   │   │   │   └── leave_balance_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── leave_repository.dart
│   │   │   └── usecases/
│   │   │       ├── apply_leave_usecase.dart
│   │   │       ├── get_leave_history_usecase.dart
│   │   │       └── get_leave_balance_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── leave_providers.dart
│   │       │   └── leave_form_provider.dart
│   │       ├── pages/
│   │       │   ├── dashboard_page.dart
│   │       │   ├── apply_leave_page.dart
│   │       │   ├── leave_history_page.dart
│   │       │   └── leave_calendar_page.dart
│   │       └── widgets/
│   │           ├── leave_balance_card.dart
│   │           ├── leave_request_tile.dart
│   │           └── status_badge.dart
│   │
│   ├── manager/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── manager_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── manager_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── manager_repository.dart
│   │   │   └── usecases/
│   │   │       ├── approve_leave_usecase.dart
│   │   │       ├── reject_leave_usecase.dart
│   │   │       └── get_team_leaves_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── manager_providers.dart
│   │       ├── pages/
│   │       │   ├── approvals_page.dart
│   │       ├── team_overview_page.dart
│   │       │   └── reports_page.dart
│   │       └── widgets/
│   │           ├── pending_leave_card.dart
│   │           └── team_member_tile.dart
│   │
│   └── super_admin/                   ← NEW: cross-school platform panel
│       ├── data/
│       │   ├── datasources/
│       │   │   └── super_admin_remote_datasource.dart
│       │   └── repositories/
│       │       └── super_admin_repository_impl.dart
│       ├── domain/
│       │   ├── repositories/
│       │   │   └── super_admin_repository.dart
│       │   └── usecases/
│       │       ├── get_all_schools_usecase.dart
│       │       ├── get_platform_stats_usecase.dart
│       │       └── manage_school_plan_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   └── super_admin_providers.dart
│           ├── pages/
│           │   ├── platform_dashboard_page.dart
│           │   ├── school_list_page.dart
│           │   └── school_detail_page.dart
│           └── widgets/
│               ├── school_stats_card.dart
│               └── plan_badge.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── loading_overlay.dart
│   │   └── error_view.dart
│   └── theme/
│       ├── app_theme.dart
│       └── app_typography.dart
│
└── main.dart

test/
├── unit/
│   ├── leave/
│   │   ├── apply_leave_usecase_test.dart
│   │   └── leave_repository_test.dart
│   ├── school/
│   │   └── onboard_school_usecase_test.dart
│   └── auth/
│       └── sign_in_usecase_test.dart
├── widget/
│   └── leave_balance_card_test.dart
└── integration/
    └── leave_flow_test.dart
```

---

## Clean Architecture Layers

| Layer | Folder | Responsibility |
|---|---|---|
| Domain | `domain/entities`, `usecases`, `repositories` | Pure Dart business logic. No Flutter or Firebase imports. |
| Data | `data/models`, `datasources`, `repositories` | Firebase calls, JSON mapping, implements domain contracts. |
| Presentation | `presentation/providers`, `pages`, `widgets` | Riverpod providers, UI widgets, user interaction. |
| Core | `core/` | Shared utilities, routing, DI, error types. |
| Shared | `shared/` | Reusable widgets and theme used across features. |

### Data Flow

```
UI widget
  → Riverpod provider
    → UseCase
      → Repository interface
        → DataSource (Firestore, schoolId scoped by Rules)
          → Result flows back as AsyncValue
```

---


## pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_messaging: ^15.0.0

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.3

  # Code generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # Routing
  go_router: ^14.0.0

  # UI
  flutter_screenutil: ^5.9.0
  table_calendar: ^3.1.0
  cached_network_image: ^3.3.0

  # Local storage
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.0
  freezed: ^2.5.2
  json_serializable: ^6.7.1
  mocktail: ^1.0.3
```

---

## Example Code

### Multi-Tenant Domain Entity

```dart
// features/leave/domain/entities/leave_request_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request_entity.freezed.dart';

@freezed
class LeaveRequestEntity with _$LeaveRequestEntity {
  const factory LeaveRequestEntity({
    required String id,
    required String schoolId,    // ← always present in multi-tenant
    required String userId,
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    String? reason,
  }) = _LeaveRequestEntity;
}
```

### Riverpod Stream Provider (Realtime, school-scoped)

```dart
// features/leave/presentation/providers/leave_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_providers.g.dart';

@riverpod
Stream<List<LeaveRequestEntity>> myLeaveRequests(
  MyLeaveRequestsRef ref,
) {
  final repo = ref.watch(leaveRepositoryProvider);
  // Firestore security rules enforce schoolId scope, but we query by it
  return repo.watchMyLeaves();
}

@riverpod
class ApplyLeaveNotifier extends _$ApplyLeaveNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> apply(LeaveRequestEntity request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(applyLeaveUseCaseProvider).call(request),
    );
  }
}
```

### Super Admin Cross-School Query

```dart
// super_admin bypasses schoolId scoping via their role
@riverpod
Future<List<SchoolEntity>> allSchools(AllSchoolsRef ref) {
  final repo = ref.watch(superAdminRepositoryProvider);
  return repo.getAllSchools();
}
```

---

## Security Checklist

- Do not commit `firebase_options.dart` if it contains sensitive server keys (though standard Firebase options are usually safe).
- Deploy and test Firestore Security Rules thoroughly before going to production.
- Every document must have a `schoolId` field with a `String` constraint.
- Every Security Rule must check `isMySchool(schoolId)` — never rely on app-layer filtering alone.
- Use Firebase Auth session — never store passwords locally.
- Restrict `super_admin` role assignment — only via Firebase Console, custom claims, or a trusted Cloud Function, never from the client.
- Store FCM tokens in `profiles.fcmToken` — rotate on each login.
- Never embed Resend / SendGrid API keys in the Flutter app — use Cloud Function environment secrets only.

---

## Recent Configurations & Fixes (May 2026)

If you are cloning this project recently, note that the following setup steps have already been handled:
- **Environment Variables**: Migrated from Supabase keys to Firebase. The `.env` file is now used solely for app-level flags (e.g. `APP_ENV=development`) while Firebase secrets are safely managed by `flutterfire configure`.
- **Firebase Auth Exceptions**: Mapped Firebase's `email-already-in-use` exceptions directly to the clean architecture's `EmailAlreadyInUseFailure` in `auth_repository_impl.dart`.
- **Routing**: Fixed `register_page.dart` and `login_page.dart` to correctly use `context.go(AppRoutes.dashboard)` upon successful authentication.
- **Git Ignore**: Added strict `.gitignore` rules to prevent Firebase config (`google-services.json`, `GoogleService-Info.plist`) and Cloud Functions secrets (`functions/.env`) from leaking into source control.
- **Security Rules**: Added the `firestore.rules` and `firebase.json` files to the project root for automated CLI deployments.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

*Leave Management System · Flutter + Firebase + Riverpod + Clean Architecture · Multi-Tenant*