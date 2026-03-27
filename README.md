# Odin + Raylib + Android Template

A clean, reusable scaffold for building games using the **Odin Programming Language** and **Raylib**, with first-class support for compiling to **Desktop (Linux/Windows)** and **Android**.

## Features
* **Entry Point:** The game entry point is located in `src/main.odin`.
* **Zero-Conf Build:** Simple `Makefile` to handle build commands.
* **Android Ready:** Pre-configured `build_android.sh` script handling C/Odin cross-compilation, linking, APK packaging, and signing.
* **Raylib 5.0:** Includes precompiled static libraries for Android (`arm64-v8a`, `armeabi-v7a`).

---

## Prerequisites

### 1. Odin Compiler
Ensure you have the latest Odin compiler installed and in your PATH.
* [Install Odin](https://odin-lang.org/docs/install/)

### 2. Android SDK & NDK
You need the Android SDK and NDK installed to compile for mobile. You can install these via Android Studio or command-line tools.

**Required Environment Variables:**
Add these to your shell config (`.bashrc` / `.zshrc`):
```bash
export ANDROID_HOME="/path/to/android/sdk"        # e.g., /opt/android-sdk or ~/Android/Sdk
export ANDROID_NDK_HOME="/path/to/android/ndk"    # e.g., /opt/android-ndk or $ANDROID_HOME/ndk/25.x.x
````

### 3\. ADB (Android Debug Bridge)

You will need `adb` installed and in your PATH for signing, packaging, and deploying the APK files.

  * *Included with Android SDK Platform-Tools.*

-----

## Customization

You can easily rename the project by editing the `NAME` variable in the `Makefile`.

```makefile
# Makefile
NAME = my_cool_game
```

-----

## How to Build & Run

### Desktop (Linux/Windows)

Compiles and runs the game natively on your machine.

```bash
make run
```

*Artifacts are saved to `build/`.*

### Android

Compiles the Odin code, links it with the Android native glue, and packages an APK.

```bash
make android
```

*The signed APK is saved to `build/game.apk`.*

### Install to Device

If your phone is connected via USB or Wi-Fi debugging:

```bash
make install
```

-----

## Wireless Debugging (Android 11+)

No USB cable? No problem.

1.  **On Phone:** Go to **Developer Options \> Wireless Debugging**.
2.  Tap **Pair device with pairing code** to see IP, Port, and Code.
3.  **On PC:** Run pair command:
    ```bash
    adb pair 192.168.1.X:PORT
    # Enter the 6-digit code when prompted
    ```
4.  **Connect:** Look at the main "Wireless debugging" screen for the *connect* port (it differs from the pair port).
    ```bash
    adb connect 192.168.1.X:PORT
    ```
5.  **Deploy:** Run `make install`.

-----

## Project Structure

```text
.
├── src/                # 📝 YOUR GAME CODE
│   └── main.odin       # Main entry point (Desktop & Android logic)
├── assets/             # 🎨 Images, Sounds, Icons
├── android/            # 🤖 Android specific sources
│   ├── AndroidManifest.xml
│   └── src/            # Java loader (NativeActivity)
├── lib/                # 📚 Precompiled Raylib Android Libraries
├── include/            # 📄 Raylib header files
├── build_android.sh    # ⚙️ The magic script for Android compilation
└── Makefile            # 🛠️ Main task runner
```

## ⚠️ Troubleshooting

  * **"Linker name 'main' reserved":** This template uses a linker flag (`-Wl,--defsym=main=android_entry`) in `build_android.sh` to map Odin's entry point to C's `main`. Do not change the procedure name `android_entry` in `src/main.odin` without updating the script.
  * **"Standard library not found":** Ensure your `ANDROID_NDK_HOME` path is correct.
```
```
