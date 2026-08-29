# Story 01: Balance Calculation Riverpod Provider

**Epic**: Epic 13 - Real-time Leave Balance & Accrual Engine  
**Assigned Member**: KKAI Kankanamge (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: Developers building quota logic.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Reactive provider calculation layer.

---

## 📝 3. User Story
*As a* backend developer  
*I want to* compute remaining leave balance via Riverpod provider  
*So that* UI stat cards display accurate real-time values  

---

## ✅ 4. Acceptance Criteria
- [x] Provider computes `totalQuota - usedDays - pendingDays`.

---

## 💻 5. Technical Design
- Provider: `lib/features/leave/presentation/providers/leave_providers.dart`
