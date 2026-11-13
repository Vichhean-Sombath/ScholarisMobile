# Scholaris

Flutter mobile client for the Scholaris school management platform.

**Repository:** https://github.com/rezio23/ScholarisApp.git

A Flutter student-attendance app migrated from the original native Android (Kotlin + Jetpack Compose) codebase. It is the mobile companion for students and connects to the Scholaris API server.

## Related Projects

- **Scholaris** — Backend API server that powers the mobile app and web client. (https://github.com/rezio23/Scholaris.git)
- **ScholarisPage** — Role-based React web application for admins, teachers, and students. (https://github.com/rezio23/ScholarisEdu.git)

## Features

- **Login** with email/password, JWT persisted securely.
- **Dashboard** showing student summary, KPIs, and recent attendance.
- **QR Scan** for attendance check-in.
- **Attendance History** with summary cards and records list.
- **Profile** with student details and logout.

## Tech Stack

- Flutter 3.x with Material 3
- Riverpod for state management and dependency injection
- Dio for networking
- `flutter_secure_storage` for token/user persistence
- `mobile_scanner` for QR scanning
- `go_router` for navigation

## Getting Started

1. **Enable Windows Developer Mode** (required for Flutter plugin symlinks on Windows):
   ```powershell
   start ms-settings:developers
   ```

2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure the API base URL**:

   Copy `.env.example` to `.env` and edit it for your environment:

   ```bash
   cp .env.example .env
   ```

   `.env` is gitignored and must never be committed. Update `API_BASE_URL` inside it, for example:

   ```env
   API_BASE_URL=https://scholarisapi.onrender.com
   ```

   Run the app with the environment file:

   ```bash
   flutter run --dart-define-from-file=.env
   ```

   Alternatively, you can pass the URL directly at build time:

   ```bash
   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/
   ```

   The default is `https://scholarisapi.onrender.com`.

4. **Run the app**:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

## Environment Variables

| Variable        | Description                          | Example                          |
|-----------------|--------------------------------------|----------------------------------|
| `API_BASE_URL`  | Base URL of the Scholaris API server | `https://scholarisapi.onrender.com` |

> **Security note:** `.env` is listed in `.gitignore` and must not be committed. Only `.env.example` is tracked as a template.

## Project Structure

```
lib/
├── core/               # Theme, constants, errors, result type
├── data/
│   ├── models/         # API DTOs
│   ├── repositories/   # Repository implementations
│   └── services/       # API client, secure storage, API services
├── domain/
│   ├── models/         # Domain models
│   └── repositories/   # Repository interfaces
├── presentation/
│   ├── providers/      # Riverpod providers/notifiers
│   ├── router.dart     # go_router configuration
│   ├── screens/        # UI screens
│   └── widgets/        # Reusable widgets
```

## Ecosystem Integration

ScholarisApp is one of three clients in the Scholaris platform:

1. **Scholaris** (this repo's sibling backend) exposes the REST API that ScholarisApp consumes for authentication, attendance records, schedules, grades, invoices, and profile data.
2. **ScholarisPage** is the React web client used by administrators and teachers to manage the school; teachers generate attendance QR codes from ScholarisPage.
3. **ScholarisApp** (this project) is the student-facing Flutter app that scans those QR codes and submits check-ins back to the Scholaris API.

### Attendance QR Flow

1. A teacher opens the **Daily Attendance** page in **ScholarisPage** and selects a class schedule.
2. ScholarisPage requests a signed QR payload from the **Scholaris API**.
3. A student opens the **QR Scan** screen in **ScholarisApp** and scans the code.
4. ScholarisApp submits the payload to the **Scholaris API**, which verifies the token, checks enrollment, and records the student as **Present**.

Make sure `API_BASE_URL` points to a running Scholaris API instance for the QR attendance and login features to work.
