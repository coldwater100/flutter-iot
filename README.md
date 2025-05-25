# Flutter IoT Template

A full-stack monorepo template for building Flutter + Python (FastAPI) + Edge IoT applications.

This template is designed for rapid prototyping and educational use cases involving:

* A mobile app (Flutter)
* A backend API (FastAPI)
* An edge device client (e.g. Jetson Nano, Raspberry Pi)

---

## Project Structure

```
flutter-iot-template/
├── flutter/          # Locally installed Flutter SDK (excluded from git)
├── flutter_app/      # Flutter mobile app source
├── backend/          # FastAPI backend server
├── edge_client/      # Python edge client (Jetson Nano / Raspberry Pi)
├── docker-compose.yml
├── Makefile
├── README.md
└── .github/workflows/  # Optional CI/CD setup
```

---

## Quick Start

### 1. Clone this repository

```bash
git clone https://github.com/yeongseon/flutter-iot-template.git
cd flutter-iot-template
```

### 2. Start backend and edge client with Docker

Depending on your OS:

* **Linux/macOS**:

```bash
docker compose up --build
```

* **macOS (Podman)**:

```bash
# Make sure Podman is installed and socket is linked with Docker CLI
alias docker=podman
podman compose up --build
```

* **Windows x86\_64 (with Docker Desktop)**:

```powershell
docker compose up --build
```

* **Windows ARM (e.g., Surface Pro X)**:

```bash
# Use WSL2 Ubuntu and run from inside it:
cd /mnt/c/Users/<username>/GitHub/flutter-iot-template
docker-compose up --build
```

* `backend`: FastAPI server at [http://localhost:8000](http://localhost:8000)
* `edge_client`: Sends `POST /data` every 5 seconds with simulated sensor data

### 3. Run Flutter app

Follow instructions in [`flutter_app/README.md`](./flutter_app/README.md)

---

## Component Overview

* [`flutter_app`](./flutter_app): Flutter UI that interacts with backend via HTTP
* [`backend`](./backend): FastAPI app with `/hello` and `/data` endpoints
* [`edge_client`](./edge_client): Python script simulating sensor data sent to backend

---

## Requirements

* Docker + Docker Compose
* Python 3.9+ (optional, for local backend testing)
* Flutter SDK 3.0+ (see below)

---

## Flutter Setup on Windows

If you are using Windows (especially ARM-based), follow these steps:

### 1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install)

Extract to `flutter/` and add to `PATH`:

```powershell
set PATH=%PATH%;C:\path\to\flutter\bin
```

### 2. Install [Android Studio](https://developer.android.com/studio)

Check these during install:

* Android SDK
* SDK Platform Tools
* Android Emulator

```bash
flutter config --android-sdk "C:\Program Files\Android\Android Studio\Sdk"
```

### 3. Install [Visual Studio Community](https://visualstudio.microsoft.com/downloads/)

* Select the **"Desktop development with C++"** workload

### 4. Install Chrome (Optional, for Flutter Web)

```powershell
set CHROME_EXECUTABLE="C:\Program Files\Google\Chrome\Application\chrome.exe"
```

### 5. Validate Setup

```bash
flutter doctor
```

---

## Flutter Setup on macOS

If you're on macOS (Intel or Apple Silicon):

### 1. Install Flutter SDK

You can install Flutter using [Homebrew](https://brew.sh):

```bash
brew install flutter
```

Alternatively, you can manually install it:

```bash
# Example: download and extract to ~/flutter
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Install Xcode

```bash
# Install from App Store or developer.apple.com
xcode-select --install
sudo xcodebuild -license
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 3. Install Android Studio (Optional)

* Android SDK
* SDK Platform Tools
* Android Emulator

After installation, if the Android SDK cannot be located automatically, configure it manually:

```bash
flutter config --android-sdk /Users/<your-username>/Library/Android/sdk
```

### 4. Install Chrome (Optional, for Flutter Web)

```bash
brew install --cask google-chrome
```

### 5. Validate Flutter Environment

```bash
flutter doctor -v
```

If you see issues related to Android SDK, Xcode, or CocoaPods:

* Install missing tools via the official links provided in the output
* For CocoaPods (required for iOS/macOS):

```bash
sudo gem install cocoapods
```

---

## License

MIT License
