# Atomberg Fan Control App (Flutter)

Flutter-based Android application developed as part of the **Atomberg Intern – App Development** assignment.

This app allows users to authenticate using Atomberg Developer credentials and control their smart fans using official APIs.

---

## Features

- Login using **API Key** and **Refresh Token**
- Fetch and display list of registered smart fans
- Fan control options:
  - Power ON/OFF
  - Speed control
  - Fan modes
  - Timer control
  - LED control
- Real-time device state synchronization
- Clean, production-ready UI

---

## Tech Stack

- **Flutter** (Android)
- Atomberg Developer REST APIs
- Provider-based state management
- Material UI

---

## APK Download

### GitHub Release (v1.0.0)

**Direct APK download:**

- **arm64-v8a** (recommended, most modern Android phones)  
  https://github.com/Vaibhav5771/atomberg-assignment/releases/download/v1.0.0/app-arm64-v8a-release.apk

- **armeabi-v7a** (older 32-bit Android devices)  
  Available under Releases

- **x86_64** (Android emulators / x86 devices)  
  Available under Releases

**Release page:**  
https://github.com/Vaibhav5771/atomberg-assignment/releases/tag/v1.0.0

---

## Build Instructions

```bash
flutter pub get
flutter run
