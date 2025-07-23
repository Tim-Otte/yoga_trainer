# Yoga Trainer

A modern Flutter app to help users create, manage, and follow custom yoga workouts.

## 🛠️ Features

- **Workout Management**: Create, edit, and delete workouts with custom poses.
- **Pose Library**: Add, edit, and organize yoga poses with details like name, description, duration, difficulty, and affected body part.
- **Body Part Selector**: Assign poses to specific body parts for targeted workouts.
- **Difficulty Levels**: Tag poses by difficulty (easy, medium, hard).
- **Workout Player**: Guided workout timer with Text-to-Speech (TTS) announcements and vibration cues.
- **Notifications**: Daily reminders to practice yoga, with customizable time and notification settings.
- **Localization**: Multi-language support and locale selection.
- **Theme Support**: Light, dark, and system theme modes.
- **Settings**: Customize TTS voice, volume, pitch, rate, and prep times for workouts and poses.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android device or emulator

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Tim-Otte/yoga_trainer.git
   cd yoga_trainer
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Build generated files:**
   ```sh
   # Generate localizations
   flutter gen-l10n
   # Generate drift code
   dart run build_runner build
   ```

4. **Run the app:**
   ```sh
   flutter run
   ```

### Building for Release

- **Play Store app bundle:**  
  ```sh
  flutter build appbundle
  ```
- **APK:**  
  ```sh
  flutter build apk --release
  ```

## 📂 Project Structure

- `lib/` - Main app source code
  - `components/` - Reusable widgets and dialogs
  - `entities/` - Data models (poses, workouts, etc.)
  - `pages/` - Screens for workouts, poses, settings, etc.
  - `services/` - Settings service/controller
  - `l10n/` - Localization files
- `assets/` - Images and other assets
- `android/` - Platform-specific code

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## 🌍 Localization

Currently only the following languages are supported:

- German
- English

If you want to add support for languages, please feel free to submit a pull request.

## ⚖️ License

This project is licensed under the MIT license. See [LICENSE](LICENSE) for details.