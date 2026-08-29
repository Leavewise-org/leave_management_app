# Story 01: Firestore Leave History Query Repository

**Epic**: Epic 14 - Leave History Data Store & Status Filter  
**Assigned Member**: KKAI Kankanamge (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: Employees checking past applications.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - List view displaying leave request cards with status chips.

---

## 📝 3. User Story
*As an* employee  
*I want to* view a historical list of all my leave requests  
*So that* I can track past and present applications  

---

## ✅ 4. Acceptance Criteria
- [ ] Queries Firestore `leave_requests` collection filtered by user ID.

---

## 💻 5. Technical Design
- Page: [leave_history_page.dart](file:///e:/leo-d/uni/community_project/leave_management_app/lib/features/leave/presentation/pages/leave_history_page.dart)
