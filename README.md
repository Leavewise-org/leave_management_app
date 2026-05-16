# Leave Management System

**Flutter · Supabase · Riverpod · Clean Architecture · Multi-Tenant**

---

## Project Overview

A full-featured, multi-tenant leave management platform built with Flutter, Supabase, and Riverpod following Clean Architecture principles. Supports multiple schools (tenants) with complete data isolation enforced at the database level via Row Level Security. Each school has its own employees, managers, and leave configuration. A super-admin role provides a cross-school platform dashboard.

Supports employee and manager workflows including leave application, approval, team calendar, and reporting — plus school onboarding, push notifications via FCM, and transactional email via Resend/SendGrid.

---

## Tech Stack

| Category | Technology | Purpose |
|---|---|---|
| Frontend | Flutter 3.x | Cross-platform UI (Android, iOS, Web) |
| Backend / DB | Supabase | PostgreSQL, Auth, Realtime, Storage, RLS |
| State management | Riverpod 2.x | Async state, providers, dependency injection |
| Code generation | freezed + json_serializable | Immutable models, JSON serialization |
| Routing | go_router | Declarative navigation with guards |
| DI / Service Locator | get_it | Dependency injection container |
| Local storage | flutter_secure_storage | Token caching, offline prefs |
| HTTP / API | supabase_flutter | Supabase Flutter SDK |
| UI components | flutter_screenutil | Responsive sizing |
| Date handling | table_calendar | Leave calendar widget |
| Push notifications | Firebase Cloud Messaging (FCM) | Cross-platform push — no Firestore used |
| Email | Resend / SendGrid | Transactional email via Edge Functions |
| Linting | flutter_lints | Code quality |
| Testing | mocktail + flutter_test | Unit and widget tests |

> **Note on Firebase:** FCM is used exclusively for push notifications. Firestore is not used — PostgreSQL via Supabase is the single source of truth for all data.

---

## Multi-Tenant Architecture

### Core Principle

Every table carries a `school_id` foreign key. Every RLS policy checks both `school_id` and the user's role. A manager at Ananda College cannot read, write, or approve leaves belonging to Royal College — enforced at the database level, not just the application layer.

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
- Supabase account (free tier at supabase.com)
- Firebase project (for FCM push notifications only)
- Git

---

## Supabase Setup

### Step 1 — Create a Supabase Project

- Go to [app.supabase.com](https://app.supabase.com) and sign in
- Click **New project** and fill in project name, database password, and region
- Wait for the project to provision (~2 minutes)
- Go to **Settings > API** and copy your Project URL and anon public key

---

### Step 2 — Run the Multi-Tenant Database Schema

Open the SQL Editor in Supabase and run the following script:

```sql
-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================================
-- SCHOOLS (tenants)
-- ============================================================
create table schools (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null,
  slug          text unique not null,          -- e.g. "ananda-college"
  logo_url      text,
  timezone      text default 'Asia/Colombo',
  plan          text check (plan in ('free','pro','enterprise')) default 'free',
  academic_year_start  date,                  -- e.g. 2025-01-01
  academic_year_end    date,                  -- e.g. 2025-12-31
  created_at    timestamptz default now()
);

-- ============================================================
-- DEPARTMENTS
-- ============================================================
create table departments (
  id          uuid primary key default uuid_generate_v4(),
  school_id   uuid references schools(id) on delete cascade not null,
  name        text not null,
  manager_id  uuid references auth.users(id),
  created_at  timestamptz default now()
);

-- ============================================================
-- USER PROFILES (extends auth.users)
-- ============================================================
create table profiles (
  id            uuid primary key references auth.users(id),
  school_id     uuid references schools(id) on delete cascade not null,
  full_name     text not null,
  role          text check (role in ('employee','manager','school_admin','super_admin')) default 'employee',
  department_id uuid references departments(id),
  avatar_url    text,
  fcm_token     text,                         -- stored for push notifications
  created_at    timestamptz default now()
);

-- ============================================================
-- LEAVE BALANCES
-- ============================================================
create table leave_balances (
  id          uuid primary key default uuid_generate_v4(),
  school_id   uuid references schools(id) on delete cascade not null,
  user_id     uuid references profiles(id) on delete cascade,
  annual      int default 20,
  sick        int default 10,
  casual      int default 6,
  comp_off    int default 0,
  year        int default extract(year from now())::int,
  unique(user_id, year)
);

-- ============================================================
-- LEAVE REQUESTS
-- ============================================================
create table leave_requests (
  id             uuid primary key default uuid_generate_v4(),
  school_id      uuid references schools(id) on delete cascade not null,
  user_id        uuid references profiles(id) on delete cascade,
  type           text check (type in ('annual','sick','casual','comp_off','unpaid')),
  start_date     date not null,
  end_date       date not null,
  days_count     int generated always as (end_date - start_date + 1) stored,
  reason         text,
  status         text check (status in ('pending','approved','rejected')) default 'pending',
  attachment_url text,
  reviewed_by    uuid references profiles(id),
  reviewed_at    timestamptz,
  created_at     timestamptz default now()
);

-- ============================================================
-- LEAVE TYPE CONFIG (per school — allows custom leave quotas)
-- ============================================================
create table leave_type_configs (
  id          uuid primary key default uuid_generate_v4(),
  school_id   uuid references schools(id) on delete cascade not null,
  type        text not null,
  label       text not null,
  default_days int not null,
  created_at  timestamptz default now(),
  unique(school_id, type)
);
```

---

### Step 3 — Configure Row Level Security

```sql
-- Enable RLS on all tables
alter table schools            enable row level security;
alter table departments        enable row level security;
alter table profiles           enable row level security;
alter table leave_requests     enable row level security;
alter table leave_balances     enable row level security;
alter table leave_type_configs enable row level security;

-- ── HELPER: get calling user's school_id ──────────────────────
create or replace function my_school_id()
returns uuid language sql stable as $$
  select school_id from profiles where id = auth.uid()
$$;

-- ── HELPER: get calling user's role ───────────────────────────
create or replace function my_role()
returns text language sql stable as $$
  select role from profiles where id = auth.uid()
$$;

-- ── PROFILES ──────────────────────────────────────────────────
create policy "Read own profile"
  on profiles for select using (id = auth.uid());

create policy "Manager reads team profiles"
  on profiles for select using (
    my_role() in ('manager','school_admin')
    and school_id = my_school_id()
  );

create policy "Super admin reads all profiles"
  on profiles for select using (my_role() = 'super_admin');

-- ── LEAVE REQUESTS ────────────────────────────────────────────
create policy "Employee reads own leaves"
  on leave_requests for select using (
    user_id = auth.uid()
    and school_id = my_school_id()
  );

create policy "Manager reads team leaves"
  on leave_requests for select using (
    my_role() in ('manager','school_admin')
    and school_id = my_school_id()
  );

create policy "Super admin reads all leaves"
  on leave_requests for select using (my_role() = 'super_admin');

create policy "Employee inserts own leave"
  on leave_requests for insert with check (
    user_id = auth.uid()
    and school_id = my_school_id()
  );

create policy "Manager updates team leave status"
  on leave_requests for update using (
    my_role() in ('manager','school_admin')
    and school_id = my_school_id()
  );

-- ── LEAVE BALANCES ────────────────────────────────────────────
create policy "Employee reads own balance"
  on leave_balances for select using (
    user_id = auth.uid()
    and school_id = my_school_id()
  );

create policy "Manager reads team balances"
  on leave_balances for select using (
    my_role() in ('manager','school_admin')
    and school_id = my_school_id()
  );

-- ── LEAVE TYPE CONFIG ─────────────────────────────────────────
create policy "School members read their config"
  on leave_type_configs for select using (school_id = my_school_id());

create policy "School admin manages config"
  on leave_type_configs for all using (
    my_role() in ('school_admin','super_admin')
    and school_id = my_school_id()
  );

-- ── SCHOOLS ───────────────────────────────────────────────────
create policy "School members read own school"
  on schools for select using (id = my_school_id());

create policy "Super admin manages all schools"
  on schools for all using (my_role() = 'super_admin');
```

---

### Step 4 — School Onboarding Function

When a new school registers, this function seeds their leave balance configuration:

```sql
create or replace function onboard_school(
  p_name text,
  p_slug text,
  p_timezone text default 'Asia/Colombo'
)
returns uuid language plpgsql as $$
declare
  v_school_id uuid;
begin
  insert into schools (name, slug, timezone)
  values (p_name, p_slug, p_timezone)
  returning id into v_school_id;

  -- Seed default leave type config
  insert into leave_type_configs (school_id, type, label, default_days)
  values
    (v_school_id, 'annual',   'Annual Leave',   20),
    (v_school_id, 'sick',     'Sick Leave',     10),
    (v_school_id, 'casual',   'Casual Leave',    6),
    (v_school_id, 'comp_off', 'Comp Off',        0);

  return v_school_id;
end;
$$;
```

---

### Step 5 — Enable Realtime

- In the Supabase dashboard go to **Database > Replication**
- Enable replication for the `leave_requests` table
- This powers live approval notifications in the app

---

## Flutter Project Setup

### Step 1 — Clone and Install

```bash
git clone https://github.com/your-org/leave-management-app.git
cd leave-management-app
flutter pub get
```

### Step 2 — Environment Configuration

Create a `.env` file at the project root (never commit this file):

```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key-here
```

Load it in `main.dart`:

```dart
// main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const ProviderScope(child: MyApp()));
}
```

### Step 3 — FCM Setup (Push Notifications)

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add your Android and iOS apps to the Firebase project
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) into the standard locations
4. Add `firebase_messaging` to `pubspec.yaml`
5. On login, request notification permission and store the FCM token in `profiles.fcm_token`

> Firestore is **not** used. FCM handles only push delivery — all data lives in PostgreSQL.

### Step 4 — Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 5 — Run the App

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
│   ├── network/
│   │   └── supabase_client.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_guards.dart        ← guards check role + school_id
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
│   │       │   ├── team_overview_page.dart
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

supabase/
└── functions/                         ← NEW: Edge Functions
    ├── notify-leave-status/
    │   └── index.ts                   ← sends push via FCM + email via Resend
    └── onboard-school/
        └── index.ts                   ← seeds school config on registration

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
| Domain | `domain/entities`, `usecases`, `repositories` | Pure Dart business logic. No Flutter or Supabase imports. |
| Data | `data/models`, `datasources`, `repositories` | Supabase calls, JSON mapping, implements domain contracts. |
| Presentation | `presentation/providers`, `pages`, `widgets` | Riverpod providers, UI widgets, user interaction. |
| Core | `core/` | Shared utilities, routing, DI, error types. |
| Shared | `shared/` | Reusable widgets and theme used across features. |

### Data Flow

```
UI widget
  → Riverpod provider
    → UseCase
      → Repository interface
        → DataSource (Supabase, school_id scoped by RLS)
          → Result flows back as AsyncValue
```

---

## Edge Functions

### `notify-leave-status`

Triggered by a Supabase database webhook when `leave_requests.status` changes. Sends a push notification to the employee's device via FCM (using their stored `fcm_token`) and a transactional email via Resend or SendGrid.

### `onboard-school`

Called during school registration. Runs the `onboard_school()` SQL function to create the school record and seed its leave type configuration.

Deploy with:

```bash
supabase functions deploy notify-leave-status
supabase functions deploy onboard-school
```

---

## pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Supabase
  supabase_flutter: ^2.3.0

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

  # Environment
  flutter_dotenv: ^5.1.0

  # Push notifications (FCM only — Firestore not used)
  firebase_core: ^3.0.0
  firebase_messaging: ^15.0.0

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
  // school_id filtering is enforced by RLS — no manual filter needed
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
// super_admin bypasses school_id scoping via the super_admin RLS role
@riverpod
Future<List<SchoolEntity>> allSchools(AllSchoolsRef ref) {
  final repo = ref.watch(superAdminRepositoryProvider);
  return repo.getAllSchools();
}
```

---

## Security Checklist

- Add `.env` to `.gitignore` — never commit credentials
- Enable RLS on every Supabase table before going to production
- Every table must have a `school_id` column with a `NOT NULL` constraint
- Every RLS policy must check `school_id = my_school_id()` — never rely on app-layer filtering alone
- Use `supabase_flutter` auth session — never store passwords locally
- Validate all leave date ranges on the server via Postgres check constraints
- Restrict `super_admin` role assignment — only via Supabase dashboard or a trusted server-side function, never from the client
- Enable Supabase audit logs for leave status changes and school configuration changes
- Store FCM tokens in `profiles.fcm_token` — rotate on each login
- Never embed Resend / SendGrid API keys in the Flutter app — use Edge Function environment variables only

---

*Leave Management System · Flutter + Supabase + Riverpod + Clean Architecture · Multi-Tenant*