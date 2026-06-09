# Leave Management System - Developer Setup Guide

Welcome to the team! We are using a shared Firebase environment for development to ensure everyone is working with the same database structure and configuration without messing up production data.

Our Development Firebase Project ID is: **`leave-management-system-example`**

Follow the steps below to get your local environment set up.

---

## 1. Prerequisites (Flutter & Firebase CLI)

Before you begin, make sure you have the following installed on your machine:

1. **Flutter SDK:**
   * Download and install from the official site: [Flutter Install Guide](https://docs.flutter.dev/get-started/install)
   * Run `flutter doctor` in your terminal and resolve any issues.
2. **Node.js:** (Required for Firebase CLI)
   * Download and install from [Node.js](https://nodejs.org/).
3. **Firebase CLI:**
   * Open your terminal and run: `npm install -g firebase-tools`
4. **FlutterFire CLI:**
   * Run: `dart pub global activate flutterfire_cli`

---

## 2. Get Access to the Firebase Dev Project

To interact with the database and authentication locally, you need access to the shared development project.

1. Ensure you have provided your Google email address to the Project Lead.
2. Look out for an invitation email to join the **`leave-management-system-example`** Firebase project.
3. Accept the invitation.

---

## 3. Local Project Setup

1. **Clone the Repository:**
   ```bash
   git clone <our-repo-url>
   cd leave_management_app
   ```

2. **Install Flutter Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Login to Firebase:**
   Login via the terminal using the Google account you used to accept the Firebase invitation:
   ```bash
   firebase login
   ```

4. **Initialize Firebase in Flutter (If not already present):**
   If the `lib/firebase_options.dart` file doesn't exist, generate it for our dev project:
   ```bash
   flutterfire configure --project=leave-management-system-example
   ```

---

## 4. Understanding Our Firebase Setup

We already have some Firebase configurations defined in the project:
* `.firebaserc`: Sets the default Firebase project to `leave-management-system-ed5eb`.
* `firebase.json`: Links our project to our Firestore security rules.
* `firestore.rules`: Contains our role-based access control rules (Super Admin, School Admin, Manager, User). 

**Important:** If you modify `firestore.rules`, you must deploy them to the Dev project so they take effect for everyone:
```bash
firebase deploy --only firestore:rules
```

---

## 5. Running the App

To run the app connected to the Dev environment:

```bash
flutter run
```

*Note: Please do not enter real/sensitive user data into the Dev database. Use mock data for all testing.*
