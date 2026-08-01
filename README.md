<p align="center">
  <img src="893%203%20BlkBg%20C.jpg" alt="893 Media Group" width="160"/>
</p>

<h1 align="center">Format to Any Converter</h1>
<p align="center">
  A native macOS application for bidirectional batch audio conversion.<br/>
  Built by <strong>893 Media Group</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey?logo=apple" alt="Platform: macOS"/>
  <img src="https://img.shields.io/badge/engine-afconvert%20%7C%20ffmpeg-blue" alt="Engine"/>
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License"/>
</p>

---

## Overview

**Format to Any Converter** (v2.0) is a lightweight, 100% native macOS utility for batch audio conversion between **WAV, MP3, M4A/AAC, FLAC, AIFF, and CAF**.

It features a clean native macOS GUI window with an interactive target format dropdown menu, folder pickers, progress tracking, and a dynamic conversion button.

Designed for music producers, audio engineers, and sound designers who need fast, flexible audio format conversion without bloated third-party software.

---

## Features

- 🖥️ **Native macOS Window GUI** — built using Swift & AppKit (100% native UI, no Electron/Python/Web wrappers)
- 🔄 **Bidirectional Multi-Format Selection** — dropdown selector lets you choose your target format:
  - **WAV** (Uncompressed 16-bit PCM)
  - **MP3** (Compressed Audio)
  - **M4A** (AAC Audio)
  - **FLAC** (Lossless Audio)
  - **AIFF** (Apple Uncompressed PCM)
  - **CAF** (Core Audio Format)
- 📁 **New Folder Creation** — create and name new output folders on the fly right inside the selection dialog
- 🔘 **Interactive Conversion Button** — activates dynamically when input & output folders are set
- 🎛️ **Dual Engine Core** — utilizes native macOS `afconvert` and automatically hooks into `ffmpeg` when available
- 📊 **Real-time Progress Indicator** — visual progress bar and status feedback during batch processing
- ✅ **Smart File Skip** — automatically skips existing output files to save processing time
- 🔒 **Standalone Bundle** — completely self-contained `.app` executable

---

## Supported Input & Target Formats

| Format | Extensions | Input | Target Output |
| --- | --- | --- | --- |
| WAV | `.wav` | ✅ | ✅ |
| MP3 | `.mp3` | ✅ | ✅ |
| AAC / M4A | `.aac`, `.m4a` | ✅ | ✅ |
| ALAC | `.m4a` | ✅ | ✅ |
| AIFF | `.aiff`, `.aif` | ✅ | ✅ |
| FLAC | `.flac` | ✅ | ✅ |
| Core Audio Format | `.caf`, `.caff` | ✅ | ✅ |
| Protected AAC | `.m4p` | ✅* | — |
| iPhone Ringtone | `.m4r` | ✅ | — |
| MPEG-4 Audio | `.mp4` | ✅ | — |

> **Note on `.m4p` files:** Legacy DRM-protected files will fail unless DRM has been removed (iTunes Plus DRM-free files convert normally).

---

## How to Use

### Option 1 — Native macOS App (`Format Converter.app`)

1. Double-click **`Format Converter.app`** (or `Audio to WAV Converter.app`).
2. Click **Select...** to pick your **Input Folder**.
3. Click **Select...** to pick your **Output Folder** (click **New Folder** if you want to create a new destination folder).
4. Choose your desired **Target Format** from the dropdown menu (e.g. `MP3`, `WAV`, `M4A`, `FLAC`).
5. Click **Convert Files**.
6. View real-time progress. Upon completion, click **Open Output Folder** to inspect your converted audio.

---

### Option 2 — CLI Tool (`mp3towav`)

```bash
chmod +x mp3towav
./mp3towav ~/Music/InputFolder -o ~/Music/OutputFolder
```

---

## License

MIT License — free to use, modify, and distribute.

---

<p align="center">
  Developed by <strong>893 Media Group</strong><br/>
  <img src="893%203%20BlkBg%20C.jpg" alt="893MG" width="80"/>
</p>
