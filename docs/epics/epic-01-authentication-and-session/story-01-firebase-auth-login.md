# Story 01: Firebase Auth Login Screen UI

**Epic**: Epic 01 - User Onboarding and Auth UI Screens  
**Assigned Member**: NM Rubasinghe (UI/UX Design & Documentation)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: All Leavewise system users (Employees, Managers, School Admins, Super Admins).
- **Core Requirements**:
  - Email address and password authentication UI.
  - Role-based dashboard redirection upon successful verification.
  - Clear error feedback snackbars for incorrect credentials.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Clean material card layout centered on screen with institution logo header.
  - Satoshi/Inter typography hierarchy.
  - Floating label text fields with password visibility toggle icon.

---

## 📝 3. User Story
*As a* Leavewise user  
*I want to* log into the application using my registered email address and password  
*So that* I can securely access my role-based dashboard  

---

## ✅ 4. Acceptance Criteria
- [ ] Email input field validates correct email syntax.
- [ ] Password field supports toggle for showing/hiding characters.
- [ ] Tapping "Login" triggers loading state and invokes auth provider.
- [ ] Errors are displayed in a clean snackbar/banner.

---

## 💻 5. Technical Design
- Page: [login_page.dart](file:///e:/leo-d/uni/community_project/leave_management_app/lib/features/auth/presentation/pages/login_page.dart)
