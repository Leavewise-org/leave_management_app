# Story 01: Admin Employee Deactivation Service

**Epic**: Epic 17 - School Admin & Super Admin System Governance  
**Assigned Member**: SSWRSR Sampath (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: School Admins managing active staff access.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Staff table list with status toggle switch (Active / Deactivated).

---

## 📝 3. User Story
*As a* School Admin  
*I want to* deactivate employee accounts when staff leave the school  
*So that* deactivated staff can no longer log in  

---

## ✅ 4. Acceptance Criteria
- [ ] Updates `isActive` flag in user document to prevent login.

---

## 💻 5. Technical Design
- Page: [manage_employees_page.dart](file:///e:/leo-d/uni/community_project/leave_management_app/lib/features/school/presentation/pages/manage_employees_page.dart)
