# Story 02: Unique School Code Uniqueness Guard

**Epic**: Epic 12 - Multi-Tenant School Registration Engine  
**Assigned Member**: BLB Avishka (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: Developers enforcing code collision prevention.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Validation check.

---

## 📝 3. User Story
*As a* developer  
*I want to* check if a school code is already taken  
*So that* every school tenant has a unique identifier  

---

## ✅ 4. Acceptance Criteria
- [ ] Queries `schools` collection for existing code matches.

---

## 💻 5. Technical Design
- Service: `lib/features/school/data/school_repository.dart`
