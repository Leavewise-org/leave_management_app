# Story 02: Riverpod Global Session State Providers

**Epic**: Epic 18 - Core GoRouter Infrastructure & Global Providers  
**Assigned Member**: SSWRSR Sampath (Frontend & Backend Development)  

---

## 🔍 1. Requirement Gathering & Business Rules
- **Target Persona**: System architecture developers.
- **Core Requirements**:
  - Global reactive session state handling user tokens, role attributes, and active school context.

---

## 🎨 2. UI/UX Design Specifications
- **Layout & Visuals**:
  - Non-blocking reactive UI updates.

---

## 📝 3. User Story
*As a* system developer  
*I want to* establish central Riverpod providers for current user session, active school ID, and Firestore services  
*So that* UI widgets can reactively rebuild when global data updates  

---

## ✅ 4. Acceptance Criteria
- [ ] Configures `currentUserProvider`, `currentSchoolProvider`, and `firebaseFirestoreProvider`.

---

## 💻 5. Technical Design
- Providers: `lib/core/providers/`
