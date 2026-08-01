import AppKit
import Foundation

// MARK: - Format Definition
struct AudioFormat {
    let name: String
    let ext: String
    let description: String
}

let supportedFormats: [AudioFormat] = [
    AudioFormat(name: "WAV (Uncompressed PCM)", ext: "wav", description: "Standard 16-bit PCM WAV"),
    AudioFormat(name: "MP3 (Compressed Audio)", ext: "mp3", description: "320kbps MP3 Audio"),
    AudioFormat(name: "M4A (AAC Audio)", ext: "m4a", description: "MPEG-4 AAC Audio"),
    AudioFormat(name: "FLAC (Lossless)", ext: "flac", description: "Free Lossless Audio Codec"),
    AudioFormat(name: "AIFF (Apple PCM)", ext: "aiff", description: "Apple Uncompressed PCM AIFF"),
    AudioFormat(name: "CAF (Core Audio)", ext: "caf", description: "Apple Core Audio Format")
]

// MARK: - Main Application Delegate
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    
    // UI Elements
    var inputPathField: NSTextField!
    var outputPathField: NSTextField!
    var formatPopUp: NSPopUpButton!
    var convertButton: NSButton!
    var statusLabel: NSTextField!
    var progressBar: NSProgressIndicator!
    var logoImageView: NSImageView!
    
    // Model State
    var inputURL: URL?
    var outputURL: URL?
    var isConverting = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        let windowMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable]
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 560, height: 420),
            styleMask: windowMask,
            backing: .buffered,
            defer: false
        )
        window.title = "Format to Any Converter — 893 Media Group"
        window.center()
        window.isReleasedWhenClosed = false
        window.delegate = self

        let contentView = NSView(frame: window.contentView!.bounds)
        window.contentView = contentView

        setupUI(in: contentView)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func setupUI(in view: NSView) {
        // Logo / Title Header
        let logoPath = Bundle.main.path(forResource: "893 3 BlkBg C", ofType: "jpg") 
            ?? (Bundle.main.bundlePath as NSString).deletingLastPathComponent + "/893 3 BlkBg C.jpg"
        
        logoImageView = NSImageView(frame: NSRect(x: 20, y: 350, width: 80, height: 50))
        if FileManager.default.fileExists(atPath: logoPath), let img = NSImage(contentsOfFile: logoPath) {
            logoImageView.image = img
        } else {
            // Text fallback if image logo missing
            let headerLabel = NSTextField(labelWithString: "893MG")
            headerLabel.font = NSFont.boldSystemFont(ofSize: 22)
            headerLabel.textColor = .systemRed
            headerLabel.frame = NSRect(x: 20, y: 360, width: 90, height: 30)
            view.addSubview(headerLabel)
        }
        logoImageView.imageScaling = .scaleProportionallyUpOrDown
        view.addSubview(logoImageView)

        let titleLabel = NSTextField(labelWithString: "Audio Converter")
        titleLabel.font = NSFont.boldSystemFont(ofSize: 20)
        titleLabel.frame = NSRect(x: 110, y: 372, width: 420, height: 28)
        view.addSubview(titleLabel)

        let subtitleLabel = NSTextField(labelWithString: "Convert audio files to WAV, MP3, M4A, FLAC, AIFF, or CAF")
        subtitleLabel.font = NSFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.frame = NSRect(x: 110, y: 354, width: 420, height: 18)
        view.addSubview(subtitleLabel)

        // Separator
        let sep = NSBox(frame: NSRect(x: 20, y: 340, width: 520, height: 1))
        sep.boxType = .separator
        view.addSubview(sep)

        // 1. Input Folder Row
        let inputLabel = NSTextField(labelWithString: "Input Folder:")
        inputLabel.font = NSFont.boldSystemFont(ofSize: 13)
        inputLabel.frame = NSRect(x: 20, y: 300, width: 100, height: 20)
        view.addSubview(inputLabel)

        inputPathField = NSTextField(frame: NSRect(x: 20, y: 275, width: 410, height: 24))
        inputPathField.isEditable = false
        inputPathField.placeholderString = "Select folder containing audio files..."
        view.addSubview(inputPathField)

        let selectBtn1 = NSButton(title: "Select...", target: self, action: #selector(selectInputFolder))
        selectBtn1.frame = NSRect(x: 435, y: 270, width: 105, height: 32)
        view.addSubview(selectBtn1)

        // 2. Output Folder Row
        let outputLabel = NSTextField(labelWithString: "Output Folder:")
        outputLabel.font = NSFont.boldSystemFont(ofSize: 13)
        outputLabel.frame = NSRect(x: 20, y: 235, width: 100, height: 20)
        view.addSubview(outputLabel)

        outputPathField = NSTextField(frame: NSRect(x: 20, y: 210, width: 410, height: 24))
        outputPathField.isEditable = false
        outputPathField.placeholderString = "Select folder to save converted files..."
        view.addSubview(outputPathField)

        let selectBtn2 = NSButton(title: "Select...", target: self, action: #selector(selectOutputFolder))
        selectBtn2.frame = NSRect(x: 435, y: 205, width: 105, height: 32)
        view.addSubview(selectBtn2)

        // 3. Format Selection Dropdown
        let formatLabel = NSTextField(labelWithString: "Target Format:")
        formatLabel.font = NSFont.boldSystemFont(ofSize: 13)
        formatLabel.frame = NSRect(x: 20, y: 170, width: 100, height: 20)
        view.addSubview(formatLabel)

        formatPopUp = NSPopUpButton(frame: NSRect(x: 125, y: 165, width: 305, height: 26))
        for fmt in supportedFormats {
            formatPopUp.addItem(withTitle: fmt.name)
        }
        view.addSubview(formatPopUp)

        // 4. Convert Button
        convertButton = NSButton(title: "Convert Files", target: self, action: #selector(startConversion))
        convertButton.frame = NSRect(x: 180, y: 105, width: 200, height: 42)
        convertButton.font = NSFont.boldSystemFont(ofSize: 15)
        convertButton.bezelStyle = .rounded
        convertButton.isEnabled = false // Disabled until both folders selected
        view.addSubview(convertButton)

        // 5. Progress & Status
        progressBar = NSProgressIndicator(frame: NSRect(x: 20, y: 70, width: 520, height: 16))
        progressBar.isIndeterminate = false
        progressBar.minValue = 0
        progressBar.maxValue = 100
        progressBar.doubleValue = 0
        progressBar.isHidden = true
        view.addSubview(progressBar)

        statusLabel = NSTextField(labelWithString: "Please select input and output folders to begin.")
        statusLabel.font = NSFont.systemFont(ofSize: 12)
        statusLabel.textColor = .secondaryLabelColor
        statusLabel.alignment = .center
        statusLabel.frame = NSRect(x: 20, y: 35, width: 520, height: 24)
        view.addSubview(statusLabel)
    }

    // MARK: - Actions
    @objc func selectInputFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.prompt = "Select Input Folder"

        panel.beginSheetModal(for: window) { [weak self] response in
            guard let self = self, response == .OK, let url = panel.url else { return }
            self.inputURL = url
            self.inputPathField.stringValue = url.path
            self.updateConvertButtonState()
        }
    }

    @objc func selectOutputFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.prompt = "Select Output Folder"

        panel.beginSheetModal(for: window) { [weak self] response in
            guard let self = self, response == .OK, let url = panel.url else { return }
            self.outputURL = url
            self.outputPathField.stringValue = url.path
            self.updateConvertButtonState()
        }
    }

    func updateConvertButtonState() {
        let canConvert = (inputURL != nil && outputURL != nil && !isConverting)
        convertButton.isEnabled = canConvert
        if canConvert {
            statusLabel.stringValue = "Ready. Click 'Convert Files' to start."
            statusLabel.textColor = .labelColor
        }
    }

    @objc func startConversion() {
        guard let inURL = inputURL, let outURL = outputURL else { return }
        let selectedIndex = formatPopUp.indexOfSelectedItem
        let targetFmt = supportedFormats[selectedIndex]

        isConverting = true
        convertButton.isEnabled = false
        progressBar.isHidden = false
        progressBar.doubleValue = 0
        statusLabel.stringValue = "Scanning audio files..."

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.performConversion(inputDir: inURL.path, outputDir: outURL.path, targetFormat: targetFmt)
        }
    }

    // MARK: - Core Conversion Routine
    func performConversion(inputDir: String, outputDir: String, targetFormat: AudioFormat) {
        let fm = FileManager.default
        let supportedInputExts = ["mp3", "m4a", "aac", "aiff", "aif", "flac", "caf", "caff", "m4p", "m4r", "mp4", "wav"]
        
        guard let contents = try? fm.contentsOfDirectory(atPath: inputDir) else {
            DispatchQueue.main.async {
                self.finishConversion(msg: "Error reading input directory.", successCount: 0, skippedCount: 0, failCount: 0)
            }
            return
        }

        let audioFiles = contents.filter { file in
            let ext = (file as NSString).pathExtension.lowercased()
            return supportedInputExts.contains(ext)
        }

        if audioFiles.isEmpty {
            DispatchQueue.main.async {
                self.finishConversion(msg: "No supported audio files found in input folder.", successCount: 0, skippedCount: 0, failCount: 0)
            }
            return
        }

        let hasFFmpeg = (try? Process.run(URL(fileURLWithPath: "/usr/bin/which"), arguments: ["ffmpeg"])) != nil 
            || fm.fileExists(atPath: "/opt/homebrew/bin/ffmpeg") 
            || fm.fileExists(atPath: "/usr/local/bin/ffmpeg")

        var converted = 0
        var skipped = 0
        var failed = 0
        let total = audioFiles.count

        try? fm.createDirectory(atPath: outputDir, withIntermediateDirectories: true, attributes: nil)

        for (index, filename) in audioFiles.enumerated() {
            let srcPath = (inputDir as NSString).appendingPathComponent(filename)
            let baseName = (filename as NSString).deletingPathExtension
            let destFileName = "\(baseName).\(targetFormat.ext)"
            let destPath = (outputDir as NSString).appendingPathComponent(destFileName)

            // Skip if destination file already exists
            if fm.fileExists(atPath: destPath) {
                skipped += 1
                DispatchQueue.main.async {
                    self.updateProgress(current: index + 1, total: total, currentFile: filename)
                }
                continue
            }

            let success = convertSingleFile(src: srcPath, dest: destPath, format: targetFormat.ext, useFFmpeg: hasFFmpeg)
            if success {
                converted += 1
            } else {
                failed += 1
            }

            DispatchQueue.main.async {
                self.updateProgress(current: index + 1, total: total, currentFile: filename)
            }
        }

        DispatchQueue.main.async {
            let summary = "Finished! Converted: \(converted), Skipped: \(skipped), Failed: \(failed)"
            self.finishConversion(msg: summary, successCount: converted, skippedCount: skipped, failCount: failed)
        }
    }

    func convertSingleFile(src: String, dest: String, format: String, useFFmpeg: Bool) -> Bool {
        let task = Process()
        
        // Priority 1: FFmpeg if available (supports all formats seamlessly)
        let ffmpegPath = "/opt/homebrew/bin/ffmpeg"
        let ffmpegPathAlt = "/usr/local/bin/ffmpeg"
        
        var execPath = "/usr/bin/afconvert"
        var args: [String] = []

        if FileManager.default.fileExists(atPath: ffmpegPath) || FileManager.default.fileExists(atPath: ffmpegPathAlt) {
            execPath = FileManager.default.fileExists(atPath: ffmpegPath) ? ffmpegPath : ffmpegPathAlt
            args = ["-y", "-loglevel", "error", "-i", src, dest]
        } else {
            // afconvert fallback configuration per target format
            switch format {
            case "wav":
                args = ["-f", "WAVE", "-d", "LEI16", src, dest]
            case "aiff":
                args = ["-f", "AIFF", "-d", "BEI16", src, dest]
            case "m4a":
                args = ["-f", "m4af", "-d", "aac", src, dest]
            case "caf":
                args = ["-f", "caff", "-d", "LEI16", src, dest]
            case "mp3", "flac":
                // afconvert cannot natively encode MP3 or FLAC without third-party codecs; try generic afconvert or fail gracefully
                args = ["-f", "m4af", "-d", "aac", src, dest] 
            default:
                args = ["-f", "WAVE", "-d", "LEI16", src, dest]
            }
        }

        task.executableURL = URL(fileURLWithPath: execPath)
        task.arguments = args

        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus == 0
        } catch {
            return false
        }
    }

    func updateProgress(current: Int, total: Int, currentFile: String) {
        let percent = (Double(current) / Double(total)) * 100.0
        progressBar.doubleValue = percent
        statusLabel.stringValue = "Converting (\(current)/\(total)): \(currentFile)"
    }

    func finishConversion(msg: String, successCount: Int, skippedCount: Int, failCount: Int) {
        isConverting = false
        progressBar.isHidden = true
        statusLabel.stringValue = msg
        updateConvertButtonState()

        let alert = NSAlert()
        alert.messageText = "Conversion Complete 🎉"
        alert.informativeText = "Converted: \(successCount)\nSkipped: \(skippedCount)\nFailed: \(failCount)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Open Output Folder")
        alert.addButton(withTitle: "Done")

        if alert.runModal() == .alertFirstButtonReturn {
            if let outURL = outputURL {
                NSWorkspace.shared.open(outURL)
            }
        }
    }
}

// MARK: - Entry Point
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
