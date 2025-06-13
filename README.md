# 🚀 Project Nova

**Project Nova** is a mobile application designed to streamline reservation and review management for Parking providers. It provides a clean and intuitive interface for users to book services, view feedback, and submit reviews, all from their smartphones.

> ⚠️ **Note:** This repository contains **only the frontend code** of Project Nova. The backend (REST API) runs locally on a development server and **is not included** in this repository.

---

## 👥 Group Members

| Name               | ID           |
|--------------------|--------------|
| Yabsira Zewdie     | UGR/9562/14  |
| Temesgen Motuma    | UGR/6382/14  |
| Tsinat Mekonnen    | UGR/7317/14  |
| Noah Yehualaeshet  | UGR/3318/14  |
| Melaku Gebreegzeabher  | NSR/1485/13  |

---

## 🛠️ Technologies Used

- **Flutter** – Cross-platform UI toolkit
- **Dart** – Programming language for Flutter
- **HTTP** – For communicating with the backend API
- **Infinite Scroll Pagination** – For efficiently loading paged data
- **Provider / Riverpod (optional)** – For state management
- **Stepper, Dialogs, and Modals** – For reservation flow and input forms

---

## 🚦 Getting Started

### Prerequisites

Make sure the following are installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / Visual Studio Code
- A physical device or emulator

### Clone the Project

```bash
git clone https://github.com/your-username/project-nova.git
cd project-nova
```

### Install Flutter Packages

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

---

## 🧪 Key Features

- 🔐 **Authentication**: JWT-based login for secure access.
- ⭐ **Review System**: Paginated, scrollable review lists with submission functionality.
- 📆 **Reservation Flow**: Multi-step dialog to collect reservation details (time, date, and service).
- 🗂️ **Dynamic Paging**: Uses the latest infinite pagination API for optimized loading.
- 📋 **Form Validation**: Ensures user input is clean and valid.
- 🖼️ **Custom Widgets**: Modular, reusable components for better code structure.

---

## 📁 Project Structure

```
lib/
├── api/                 # Network service classes
│   └── remote_api.dart
├── models/              # Data models like Review, Lot, etc.
├── pages/               # Screens such as HomePage, ReviewPage, etc.
├── widgets/             # Shared UI components (e.g. CustomStepper)
├── utils/               # Helper functions and constants
└── main.dart            # App entry point
```

---

## 💬 Notes

- The **backend API** is not included. 
- Backend endpoints include:
  - `POST /v1/reviews` – Submit a new review
  - `GET /v1/reviews` – Get paginated reviews (`lotId`, `offset`, `limit`)

---

## 📞 Contact

If you have questions or feedback, please contact the team or submit an issue in the repository.
