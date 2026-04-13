# Smart Utility Toolkit

A clean, modern Flutter mobile application that bundles everyday utility tools into a single, beautifully designed app. Built with Material 3 and designed for both light and dark themes out of the box.

## 🚀 Live Demo

Try the app instantly in your browser — no install required:

**[▶ Launch on Appetize](https://appetize.io/app/b_kfxndl2xxmm44q5pspwc7xvp6q)**

---

## ✨ Features

### 🔄 Unit Converter
Convert between units across three categories with real-time results as you type:
- **Length** — Meters, Kilometers, Centimeters, Miles, Yards, Feet, Inches
- **Temperature** — Celsius, Fahrenheit, Kelvin
- **Weight** — Kilograms, Grams, Pounds, Ounces

### 📝 Notes
A lightweight note-taking tool with full CRUD functionality:
- Create, read, update, and delete notes
- Notes persist across sessions via `shared_preferences`
- Clean card-based UI with overflow handling

### 🔐 Password Generator
Generate strong, randomised passwords with customisable options:
- Adjustable length (6–32 characters)
- Toggle uppercase, lowercase, numbers, and symbols
- One-tap copy to clipboard

---

## 🛠 Tech Stack

| Layer              | Technology                          |
|--------------------|-------------------------------------|
| **Framework**      | Flutter (Dart)                      |
| **Design System**  | Material 3 (`useMaterial3: true`)   |
| **State Management** | Provider                          |
| **Typography**     | Google Fonts (Inter)                |
| **Local Storage**  | Shared Preferences                  |
| **Min SDK**        | Dart ≥ 3.9.2                        |

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point & theme configuration
├── models/
│   └── note.dart                      # Note data model
├── providers/
│   └── notes_provider.dart            # Notes state management (ChangeNotifier)
└── screens/
    ├── home_screen.dart               # Dashboard with tool grid
    ├── unit_converter_screen.dart      # Unit conversion (length, temp, weight)
    ├── notes_screen.dart              # Notes list view
    ├── note_editor_screen.dart        # Create / edit note
    └── password_generator_screen.dart # Password generation with options
```

---

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.9.2)
- An emulator, simulator, or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/smart_utility_toolkit.git
cd smart_utility_toolkit

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📸 Screenshots

| Home | Unit Converter | Password Generator |
|------|----------------|--------------------|
| Grid dashboard with tool cards | Real-time conversion with category selector | Configurable password with copy support |

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
