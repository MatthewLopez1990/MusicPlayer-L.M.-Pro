# MusicPlayer-L.M. Pro 🎵

<p align="center">
  <img src="MusicPlayer-LM/Resources/Assets.xcassets/AppIcon.appiconset/Icon-1024.png" alt="App Icon" width="180" style="border-radius: 40px; box-shadow: 0px 10px 20px rgba(0,0,0,0.15);">
  <br><br>
  <b>A high-fidelity, offline music workstation for iOS.</b>
  <br>
  <i>Listen, visualize, and shape your sound with studio-grade tools.</i>
</p>

## 📖 About
**MusicPlayer-L.M. Pro** goes beyond a standard music player. It transforms your local music library into an immersive audio experience. Designed for audiophiles and creative listeners, it features a professional **20-band equalizer**, real-time **audio synthesis effects** (Pitch, Speed, Reverb), and stunning **audio-reactive visualizers** that bring your music to life.

Built with privacy as a priority, it works entirely offline with your existing files—no accounts, no ads, and no data tracking.

---

## 📸 Screenshots

<p align="center">
  <img src="MusicPlayer-LM/Resources/Assets.xcassets/Screenshots/IMG_2124.jpg" width="220" style="margin: 10px; border-radius: 15px;" alt="Library View">
  <img src="MusicPlayer-LM/Resources/Assets.xcassets/Screenshots/IMG_2125.jpg" width="220" style="margin: 10px; border-radius: 15px;" alt="Player View">
  <img src="MusicPlayer-LM/Resources/Assets.xcassets/Screenshots/IMG_2126.jpg" width="220" style="margin: 10px; border-radius: 15px;" alt="Visualizer">
  <img src="MusicPlayer-LM/Resources/Assets.xcassets/Screenshots/IMG_2127.jpg" width="220" style="margin: 10px; border-radius: 15px;" alt="Equalizer">
</p>

---

## ✨ Features

*   **Audio Engine**: High-fidelity playback using `AVAudioEngine`.
*   **Visualizers**: Three distinct, randomized themes:
    *   🌆 **Synthwave 80s**
    *   🌈 **Tie-Dye**
    *   ✨ **Particle Constellation**
*   **Equalizer**: Professional 20-band equalizer with presets (Rock, Pop, Jazz, etc.).
*   **Effects**: Real-time Pitch, Speed, and Reverb controls.
*   **Metadata Editor**: Edit artist names directly within the app context menu.
*   **Privacy**: Fully offline, no data collection.

## 🚀 How to Install

### Option 1: Using Xcode (Free)
**Prerequisites:** You must have a Mac with **Xcode** installed (download for free from the Mac App Store).

1.  **Download** this repository (Code -> Download ZIP) or clone it.
2.  Launch the **Xcode** application on your Mac.
3.  Open the `MusicPlayer-LM.xcodeproj` file from within Xcode.
4.  Connect your iPhone to your Mac via USB cable.
5.  In Xcode's top toolbar, click the device selector (usually says "Any iOS Device" or a simulator name) and choose your connected iPhone.
6.  Press **Cmd+R** on your keyboard or click the **Play (▶️)** button in the top-left corner of Xcode to build and install the app.
7.  *Note:* On your iPhone, you may need to go to **Settings -> General -> VPN & Device Management** to "Trust" the app developer certificate before it will launch.

### Option 2: App Store Deployment
If you are the developer deploying this app:
1.  Ensure you have a paid Apple Developer Account.
2.  Run the automated build script included in this repo:
    ```bash
    ./build_for_appstore.sh
    ```
3.  Upload the generated `.ipa` file using the **Transporter** app.

## 🛠 Project Structure
*   `Services/`: `AudioEngineManager` (Core Audio) & `LibraryManager` (File Access).
*   `ViewModels/`: `PlayerViewModel` (Logic) & `EqualizerViewModel`.
*   `Views/`: SwiftUI Interfaces (`PlayerView`, `LibraryView`, `EqualizerView`).
*   `Models/`: Data structures (`Song`, `EqualizerPreset`).

## ⚠️ Important Note on Signing
This project uses **Automatic Signing**.
*   **Team ID**: If building via command line, ensure your Apple Developer Team ID is set in Xcode.
*   **Bundle ID**: `DevSwap.MusicPlayer-LM`.

## Privacy
This app does not collect data. It only reads audio files you explicitly select via the system document picker.

---
*Created by Matthew Lopez*
