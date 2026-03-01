# 🎧 Nine-SM

**An audiophile-grade, 24-bit FLAC audio streamer and player built for high-end In-Ear Monitors (IEMs).**

![Nine-SM Banner](https://via.placeholder.com/1000x300/12011a/D0BCFF?text=Nine-SM+Audio+Player) 
*(Note: Replace this placeholder link with an actual screenshot of your app later!)*

---

## 🎵 The Philosophy
Standard music players are built for standard headphones. **Nine-SM** is engineered specifically for the audiophile community. By combining true 24-bit/96kHz audio streaming with a hardware-level, normalized DSP matrix, Nine-SM delivers studio-reference sound customized for legendary IEM hardware.

## ✨ Key Features

* **High-Fidelity Engine:** Native support for 24-bit FLAC streaming to ensure zero compression loss.
* **Precision IEM Targets:** Features a 10-band hardware equalizer with mathematically normalized presets specifically tuned for:
  * Truthear Zero (Red & Blue)
  * Simgot EW300
  * BLON BL-07
* **Seamless Queue Management:** A premium, dark-themed "Up Next" bottom sheet featuring fluid Swipe-to-Remove gesture controls.
* **Dynamic UI:** A heavily customized Material 3 interface built on a deep-purple (`#12011a`) aesthetic that is easy on the eyes in dark environments.
* **Ultra-Responsive State:** Powered by Riverpod for zero-latency UI updates between the audio engine and the playback screens.

## 📸 Screenshots
<div align="center">
  ![WhatsApp Image 2026-03-02 at 2 22 13 AM](https://github.com/user-attachments/assets/dcf7eeee-2157-45e8-a16c-d824ff615267)

  ![WhatsApp Image 2026-03-02 at 2 22 13 AM (1)](https://github.com/user-attachments/assets/8375ad04-d35d-4810-b933-7d97af176b2a)

  ![WhatsApp Image 2026-03-02 at 2 22 13 AM (2)](https://github.com/user-attachments/assets/4d71d586-1808-4103-b5d8-9e6d76e2b63b)

  ![WhatsApp Image 2026-03-02 at 2 22 14 AM](https://github.com/user-attachments/assets/2f6ebd6e-3ba1-4e14-bf09-bdf54206ac35)

</div>

## 🛠️ Technical Architecture
* **Framework:** Flutter / Dart
* **State Management:** Riverpod (`flutter_riverpod`)
* **Audio Engine:** Custom implementation utilizing `just_audio` & `audio_service`
* **Local Storage:** SQLite & Shared Preferences
* **UI/UX:** Material 3 / Dynamic Color

## 🚀 Getting Started

### 📥 Install the APK (Android Only)
You can download the latest highly-optimized release build directly from the [Releases Tab](../../releases).

### 💻 Build from Source
1. Clone the repository:
   ```bash
   git clone [https://github.com/Nishant-404/Nine-SM.git](https://github.com/Nishant-404/Nine-SM.git)
