# 🌴 Leave Feature Architecture Guide

Welcome to the `leave` feature! If you are a beginner looking at this folder and wondering what everything does, you are in the right place. 

This feature is built using a pattern called **Clean Architecture**.

---

## 🍔 The Restaurant Analogy
Before we look at the folders, let's imagine this app is a restaurant:
1. **The Menu & Waiter (Presentation Layer):** This is what the customer sees and interacts with. The waiter takes your order.
2. **The Kitchen Rules & Recipes (Domain Layer):** This dictates *what* food can be made and the strict rules for making it, but it doesn't actually cook it.
3. **The Kitchen Staff & Ingredients (Data Layer):** These are the people who actually go to the fridge, get the ingredients, and cook the food following the rules.

Let's look at how our folders match this analogy.

---

## 📁 Folder Breakdown

### 1. `domain/` (The Kitchen Rules & Recipes)
This folder is the **core** of our feature. It doesn't know anything about Firebase, the Internet, or UI screens. It just knows the pure business rules.

* **`entities/`**: These are pure Dart objects. Think of them as the absolute purest definition of what a "Leave" is (e.g., it has a start date, an end date, and a reason).
* **`repositories/`**: These are *interfaces* (abstract classes). They say **WHAT** the app can do, but not **HOW** it does it. For example, it says "We must be able to `submitLeave()`", but it doesn't care if that leave is saved in Firebase, an SQL database, or written on a piece of paper.
* **`usecases/`**: (See note at the bottom). Normally, this contains classes representing specific actions (like `ApproveLeaveUseCase`).

### 2. `data/` (The Kitchen Staff & Ingredients)
This folder is the "engine room". It does the dirty work of talking to the outside world (like Firebase).

* **`datasources/`**: The code that actually talks to the database. For example, `leave_remote_datasource.dart` is where we write `FirebaseFirestore.instance...` to send data to the cloud.
* **`models/`**: These are very similar to `entities`, but with extra code. They handle converting JSON data from Firebase into a Dart object, and converting a Dart object back into JSON for Firebase.
* **`repositories/`**: This is where we implement the rules defined in the `domain` layer. `leave_repository_impl.dart` acts as the manager: it takes the data from the `datasource`, converts it using the `model`, and passes it back to the app.

### 3. `presentation/` (The Menu & Waiter)
This is the only folder the user actually sees.

* **`pages/`**: The main screens of the app (e.g., the "Request Leave" screen).
* **`widgets/`**: Reusable visual components (e.g., a "Status Badge" widget).
* **`providers/`**: This is our **Riverpod State Management**. It acts as the bridge between the UI and the Data. When a user clicks a button on a page, the page tells the provider, and the provider talks to the repository to get or save the data.

---

## 🔄 How Data Flows (The Journey of a Leave Request)

When a user clicks "Submit Leave" on their phone, here is the exact journey the data takes through our folders:

1. **`presentation/pages/`**: The user taps the "Submit" button on the UI screen.
2. **`presentation/providers/`**: The screen immediately calls the Riverpod Provider (e.g., `SubmitLeaveNotifier`).
3. **`domain/repositories/`**: The Provider looks at the interface (`LeaveRepository`) to see the rules on how to submit a leave.
4. **`data/repositories/`**: The implementation (`LeaveRepositoryImpl`) actually receives the request from the Provider. It prepares to send it.
5. **`data/datasources/`**: The Repository asks the remote datasource (`LeaveRemoteDatasource`) to finally send the request over the internet to Firebase.
6. **(The Return Trip)**: Firebase replies "Success!". The datasource tells the repository, the repository tells the provider, and the provider updates the screen to show a green checkmark! ✅

---

## 🤔 Why Do We Do This?
You might be wondering: *"Why do we have 3 different folders just to save data to Firebase?"*

1. **Easier to Fix Bugs:** If a button looks weird, you know the bug is in `presentation`. If the app crashes when saving to Firebase, you know the bug is in `data`. You don't have to search through thousands of lines of code.
2. **Easier to Change Later:** If tomorrow we decide to stop using Firebase and start using Supabase, we **only** have to change the `data` folder. The `presentation` and `domain` folders won't even know anything changed!
3. **Easier to Work Together:** One developer can work on the UI (`presentation`) while another developer works on the database (`data`) at the exact same time without breaking each other's code.

---

## 🕵️‍♂️ Special Note: Why is the `usecases` folder empty?

If you look inside `domain/usecases`, you will see it is completely empty. Why?

In strict Clean Architecture, every action must go through a UseCase class. However, our app currently has very simple business logic (we are mostly just saving and fetching data).

To avoid writing unnecessary "boilerplate" code, our **Riverpod Providers** (in `presentation/providers/leave_providers.dart`) are currently acting as our UseCases. They talk directly to the `LeaveRepository`. 

* **Keep it empty:** As long as our logic is simple (just CRUD operations), this is perfectly fine and practical!
* **Use it later:** If our app gets very complex (e.g., submitting a leave requires checking holiday calendars, calculating payroll deductions, and updating three different databases), we will create UseCase classes to handle that complex logic so our Providers stay clean.
