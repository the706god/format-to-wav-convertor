<p align="center">
  <img src="893%203%20WhBkg%20C.png" alt="893 Media Group" width="160"/>
</p>

<h1 align="center">Format to WAV Converter</h1>
<p align="center">
  A native macOS tool for batch-converting audio files to uncompressed WAV format.<br/>
  Built by <strong>893 Media Group</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey?logo=apple" alt="Platform: macOS"/>
  <img src="https://img.shields.io/badge/engine-afconvert%20%7C%20ffmpeg-blue" alt="Engine"/>
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License"/>
</p>

---

## Overview

**Format to WAV Converter** is a lightweight, dependency-free macOS utility that converts a folder of audio files into uncompressed **WAV (PCM 16-bit)** format using Apple's native `afconvert` engine — or `ffmpeg` if installed. It ships as both a double-clickable **macOS app** with native folder-picker dialogs and a **command-line tool** for terminal workflows.

Designed for music producers, audio engineers, and sound designers who need to bulk-convert libraries out of compressed or proprietary formats quickly, with no setup required.

---

## Features

- 🖥️ **Native macOS GUI** — uses built-in system dialogs (no Electron, no Python, no browser)
- ⚡ **Fast batch conversion** — processes entire folders in one click
- 🎛️ **Dual engine** — uses macOS `afconvert` natively; auto-detects `ffmpeg` if installed
- 📁 **Flexible output** — choose any destination folder independently of the source
- ✅ **Skip existing files** — won't re-convert files already present in the output folder
- 📊 **Results summary** — shows converted / skipped / failed counts after every run
- 🔒 **Self-contained** — the `.app` bundle includes everything it needs; move it anywhere

---

## Supported Input Formats

| Format | Extensions | Notes |
|--------|-----------|-------|
| MP3 | `.mp3` | Most common lossy format |
| AAC | `.aac`, `.m4a`, `.mp4` | Apple/iTunes standard lossy |
| ALAC | `.m4a` | Apple Lossless — open standard |
| AIFF | `.aiff`, `.aif` | Apple's uncompressed PCM format |
| FLAC | `.flac` | Free Lossless Audio Codec |
| Core Audio Format | `.caf`, `.caff` | Logic Pro, GarageBand, system audio |
| Protected AAC | `.m4p` | Legacy iTunes DRM — converts only if DRM-free |
| iPhone Ringtone | `.m4r` | AAC container used for ringtones |
| MPEG-4 Audio | `.mp4` | Video container with audio track |

> **Note on `.m4p` files:** Files purchased from the iTunes Store before 2009 may still carry DRM and will fail to convert. Files that were upgraded to DRM-free (iTunes Plus) will convert normally.

---

## Installation

No installation required. Simply clone or download the repository.

```bash
git clone https://github.com/the706god/format-to-wav-convertor.git
```

### Requirements

- **macOS 10.14 Mojave or later**
- `afconvert` — included with macOS (no install needed)
- `ffmpeg` — optional; install via [Homebrew](https://brew.sh) for broader format support:
  ```bash
  brew install ffmpeg
  ```

---

## Usage

### Option 1 — macOS App (Recommended)

1. Open the project folder in Finder
2. Double-click **`Audio to WAV Converter.app`**
3. Follow the two-step native folder picker:
   - **Step 1:** Select the folder containing your audio files
   - **Step 2:** Select the folder where WAV files should be saved
4. Review the confirmation dialog showing the file count
5. Click **Convert**
6. View the results summary — optionally click **Open Output Folder** when done

> **First launch only:** macOS may show a security prompt since the app isn't from the App Store. Go to **System Settings → Privacy & Security** and click **"Open Anyway"**.

---

### Option 2 — Command Line

Make the script executable once:

```bash
chmod +x mp3towav
```

**Basic usage — convert current directory:**
```bash
./mp3towav
```

**Convert a specific folder:**
```bash
./mp3towav ~/Music/MyAlbum
```

**Convert to a specific output directory:**
```bash
./mp3towav ~/Music/MyAlbum -o ~/Music/MyAlbum-WAV
```

**Force overwrite existing WAV files:**
```bash
./mp3towav ~/Music/MyAlbum -o ~/Music/MyAlbum-WAV --force
```

**Full options reference:**
```
Usage: mp3towav [OPTIONS] [DIRECTORY]

Options:
  -o, --output DIR    Specify output directory for WAV files
  -f, --force         Overwrite existing WAV files
  -h, --help          Show this help message
```

---

## Project Structure

```
format-to-wav-convertor/
├── Audio to WAV Converter.app/          # Self-contained macOS app bundle
│   └── Contents/
│       └── Resources/
│           └── convert_files.zsh        # Embedded conversion engine (zsh)
├── converter.applescript                # Source code for the .app
├── convert_files.zsh                    # Standalone conversion engine
├── mp3towav                             # CLI batch converter script
└── 893mg-logo.png                       # 893 Media Group logo
```

---

## How It Works

1. **GUI layer** (`converter.applescript`) — handles folder selection and dialogs using macOS AppleScript
2. **Conversion engine** (`convert_files.zsh`) — runs under `/bin/zsh`, uses `afconvert -f WAVE -d LEI16` (or `ffmpeg -y`) to convert each file
3. The engine outputs results as `converted|skipped|failed|failedNames` which the GUI parses and displays

The `.app` bundle has `convert_files.zsh` **embedded inside** `Contents/Resources/`, making it fully portable — no external files needed.

---

## Output Format

All files are converted to:

| Property | Value |
|---|---|
| Container | WAV (RIFF) |
| Codec | PCM Linear (uncompressed) |
| Bit depth | 16-bit |
| Sample rate | Preserved from source |

---

## License

MIT License — free to use, modify, and distribute.

---

<p align="center">
  Developed by <strong>893 Media Group</strong><br/>
  <img src="893%203%20WhBkg%20C.png" alt="893MG" width="80"/>
</p>
