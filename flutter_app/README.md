# Flutter App

This is the Flutter mobile and desktop app included in the `flutter-iot-template` project.

---

## 🧪 Hello World + FastAPI API Call

This app demonstrates:

- A simple "Hello from Flutter!" message by default
- Fetching a greeting from a FastAPI backend endpoint `/hello` on startup
- Running on macOS, Android emulator, or real devices

---

## ⚙️ Install & Run

### 🔹 Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0+ recommended)
- Android Studio / iOS Simulator / Physical device
- FastAPI backend running locally on port `8000`:
  ```bash
  uvicorn main:app --host 0.0.0.0 --port 8000
  ```

---

### 🔹 Option 1: Install Flutter SDK

#### 🐧 On Linux

```bash
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz
tar xf flutter_linux_3.22.1-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
flutter --version
```

#### 🪟 On Windows (PowerShell)

1. Download from https://docs.flutter.dev/get-started/install/windows
2. Extract and add `flutter/bin` to your PATH
3. Run: `flutter --version`

#### 🍎 On macOS

```bash
brew install --cask flutter
flutter doctor
```

If using local SDK (included in this repo), run:

```bash
export PATH="$PATH:$(pwd)/flutter/bin"
flutter --version
```

> ✅ If building for iOS/macOS, you need to install **Xcode** and accept the license:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

---

### 🔹 Option 2: Run the App

```bash
cd flutter_app
flutter pub get
flutter run
```

✅ Make sure a device or emulator is running!

To explicitly run on macOS desktop:

```bash
flutter run -d macos
```

---

## 🔄 API Integration

The app sends an HTTP GET request to the FastAPI backend:

```
GET http://localhost:8000/hello
```

📌 **Note:**
- On **Android emulator**, use `http://10.0.2.2:8000/hello`
- On **macOS**, **iOS**, or **Windows**, use `http://localhost:8000/hello`

The app automatically selects the correct URL based on the platform.

---

## 📦 Dependencies

```yaml
dependencies:
  http: ^0.13.6
```

---

## 🔍 API Integration Code Overview (`lib/main.dart`)

### 1. Import packages

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
```

### 2. Choose correct base URL by platform

```dart
String getBaseUrl() {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  } else {
    return 'http://localhost:8000';
  }
}
```

### 3. Fetch from API

```dart
final response = await http.get(Uri.parse('${getBaseUrl()}/hello'));
```

### 4. Update UI with message

```dart
setState(() {
  _message = data['message'] ?? 'No message';
});
```

---

## 🍎 macOS Notes

If you are targeting macOS:

- Add the following to both `macos/Runner/DebugProfile.entitlements` and `Release.entitlements`:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

- This allows network access from the Flutter macOS app
- You can build and run with:

```bash
flutter run -d macos
```

---

## 📁 File Structure

```
flutter/
├── flutter_app/       # Flutter source code (main.dart, pubspec.yaml, etc.)
├── flutter/           # (optional) Local Flutter SDK if bundled
├── macos/             # macOS platform config and entitlements
└── README.md          # This file
```

---

## ✅ Tips

- macOS requires entitlements to allow network access (`DebugProfile.entitlements`, `Release.entitlements`)
- Make sure Docker backend has port `8000` exposed via `ports: ["8000:8000"]`
- Always verify backend is running by:
  ```bash
  curl http://localhost:8000/hello
  ```

---

Happy coding! 🚀
