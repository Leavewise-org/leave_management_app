# Story 03: Quota Exceeded Safety Check Service

**Epic**: Epic 13 - Real-time Leave Balance & Accrual Engine  
**Assigned Member**: KKAI Kankanamge (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: Developers validating submission limits.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Validation rule handler.

---

## 📝 3. User Story
*As a* developer  
*I want to* block leave submissions when requested days exceed available quota  
*So that* negative leave balances are prevented  

---

## ✅ 4. Acceptance Criteria
- [x] Returns validation error if requested duration > remaining balance.

---

## 💻 5. Technical Design
- Service: `lib/features/leave/domain/leave_validation.dart`
