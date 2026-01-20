# MusicPlayer-L.M. Pro 🎵

A professional, local iOS music player built with Swift and SwiftUI.

## Features
*   **Audio Engine**: High-fidelity playback using `AVAudioEngine`.
*   **Visualizers**: Three distinct, randomized themes (Synthwave 80s, Tie-Dye, Particle Constellation).
*   **Equalizer**: Professional 20-band equalizer with presets (Rock, Pop, Jazz, etc.).
*   **Effects**: Real-time Pitch, Speed, and Reverb controls.
*   **Metadata**: Edit artist names directly within the app.
*   **Privacy**: Fully offline, no data collection.

## 🚀 How to Install (For Users)

### Option 1: Using Xcode (Free)
1.  **Download** this repository (Code -> Download ZIP) or clone it.
2.  Open `MusicPlayer-LM.xcodeproj` in **Xcode** (Mac only).
3.  Connect your iPhone via USB.
4.  Select your phone in the top-left device selector.
5.  Press **Cmd+R** (or the Play button) to build and install.
6.  *Note:* You may need to go to **Settings -> General -> VPN & Device Management** on your phone to "Trust" the app after installing.

### Option 2: Using AI Agents (Claude/OpenCode)
If you are an AI Agent trying to deploy this for a user:
1.  Ensure `xcodebuild` is installed on the host machine.
2.  The project is located in `MusicPlayer-LM/`.
3.  Build scheme: `MusicPlayer-LM`.
4.  Dependencies: Pure Swift/SwiftUI (no CocoaPods/SPM setup required).

## 🛠 Project Structure
*   `Services/`: `AudioEngineManager` (Core Audio) & `LibraryManager` (File Access).
*   `ViewModels/`: `PlayerViewModel` (Logic) & `EqualizerViewModel`.
*   `Views/`: SwiftUI Interfaces (`PlayerView`, `LibraryView`, `EqualizerView`).
*   `Models/`: Data structures (`Song`, `EqualizerPreset`).

## ⚠️ Important Note on Signing
This project uses **Automatic Signing**.
*   **Team ID**: If building via command line, ensure your Apple Developer Team ID is set in Xcode or passed to `xcodebuild`.
*   **Bundle ID**: `DevSwap.MusicPlayer-LM`. You may need to change this if you fork the project to avoid conflicts.

## Privacy
This app does not collect data. It only reads audio files you explicitly select via the system document picker.

---
*Created by Matthew Lopez*
