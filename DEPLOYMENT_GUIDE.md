# Deployment Guide: MusicPlayer-L.M. Pro

Congratulations on finishing your first app! This guide will help you navigate the App Store submission process, focusing on **Safety** and **Trust**.

## Phase 1: Preparation (Already Started)
We have already configured your app for technical compliance:
- [x] **Background Audio Mode**: Enabled so music plays when locked.
- [x] **File Sharing**: Enabled so users can import music.
- [x] **Encryption Exemption**: Configured to avoid complex export forms.
- [x] **Privacy Policy**: Use the `PRIVACY_POLICY_TEMPLATE.md` included in this folder.

## Phase 2: Apple Developer Account
1.  Go to [developer.apple.com](https://developer.apple.com).
2.  Enroll in the **Apple Developer Program** ($99/year). This verifies your identity (building **Trust** with users).

## Phase 3: App Store Connect (The Metadata)
1.  Log in to [App Store Connect](https://appstoreconnect.apple.com).
2.  **My Apps** -> **(+) New App**.
3.  **Name**: `MusicPlayer-L.M. Pro`
4.  **Privacy Policy URL**: Host the text from `PRIVACY_POLICY_TEMPLATE.md` on a free site like GitHub Pages, Google Sites, or Notion. Paste that link here.
5.  **Age Rating**:
    -   Select "None" for violence, gambling, nudity, etc.
    -   Select "Unrestricted Web Access" -> **No** (Since you only play local files).
    -   Result should be **4+** (Safe for everyone).

## Phase 4: Archiving & Uploading (Automated Method)
We have created a script to handle the complex build process for you.

1.  Open Terminal.
2.  Navigate to your project folder:
    `cd "/Users/matthewlopez/iOS Apps/Music library and player/MusicPlayer-LM"`
3.  Run the build script:
    `./build_for_appstore.sh`
4.  **Wait**. The script will:
    *   Clean your project.
    *   Create a release Archive.
    *   Export a ready-to-upload `.ipa` file.
5.  **Upload**:
    *   When the script finishes, it will show you where the file is (usually `build/Export/MusicPlayer-LM.ipa`).
    *   Open the **Transporter** app (Free from Mac App Store).
    *   Sign in with your Apple ID.
    *   Drag the `.ipa` file into Transporter.
    *   Click **Deliver**.

## Phase 5: App Review (Crucial for Trust)
When you submit for review, you will see a section called **"App Review Information"**.
**THIS IS WHERE YOU BUILD TRUST.**

Fill it out like this:
*   **Sign-in required?** Uncheck (Your app doesn't have accounts).
*   **Notes:**
    > "This is a local music player app. It does not provide any content. Users must import their own audio files using the system Document Picker. The app requires Background Audio mode to continue playback when the device is locked, which is standard behavior for a music player. We use `startAccessingSecurityScopedResource` to securely access user-selected files."

## Checklist for "Safety"
-   **Copyright**: Since you do NOT include music files in the app bundle, you are safe. You are providing a tool, not content.
-   **Data Safety**: You are not collecting user data. Your privacy policy reflects this.

Good luck!
