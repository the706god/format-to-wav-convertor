-- Audio to WAV Converter
-- Self-contained: convert_files.zsh is embedded inside this app bundle.

-- Locate the embedded conversion script inside the app's Resources folder
set scriptPath to POSIX path of (path to resource "convert_files.zsh")

-- Step 1: Pick input folder
set inputFolder to ""
try
	set chosenInput to choose folder with prompt "Step 1 of 2 — Select the INPUT folder containing your audio files (MP3, M4A, AAC, FLAC, AIFF, CAF, M4P, M4R, MP4):"
	set inputFolder to POSIX path of chosenInput
on error
	return
end try
if inputFolder ends with "/" then set inputFolder to text 1 thru -2 of inputFolder

-- Step 2: Pick output folder
set outputFolder to ""
try
	set chosenOutput to choose folder with prompt "Step 2 of 2 — Select the OUTPUT folder where converted WAV files will be saved:"
	set outputFolder to POSIX path of chosenOutput
on error
	return
end try
if outputFolder ends with "/" then set outputFolder to text 1 thru -2 of outputFolder

-- Step 3: Count supported audio files
set fileCount to (do shell script "find " & quoted form of inputFolder & " -maxdepth 1 -type f \\( -iname '*.mp3' -o -iname '*.m4a' -o -iname '*.aac' -o -iname '*.aiff' -o -iname '*.aif' -o -iname '*.flac' -o -iname '*.caf' -o -iname '*.caff' -o -iname '*.m4p' -o -iname '*.m4r' -o -iname '*.mp4' \\) | wc -l | tr -d ' '") as integer

if fileCount is 0 then
	display alert "No Audio Files Found" message "No supported audio files (MP3, M4A, AAC, FLAC, AIFF, CAF, M4P, M4R, MP4) were found in:" & return & inputFolder as critical
	return
end if

-- Step 4: Confirm before converting
set confirmBtn to button returned of (display dialog "Ready to convert " & fileCount & " audio file(s)." & return & return & "📂  Input:   " & inputFolder & return & "📁  Output: " & outputFolder & return & return & "Proceed?" buttons {"Cancel", "Convert"} default button "Convert" with title "Audio to WAV Converter")
if confirmBtn is not "Convert" then return

-- Step 5: Run conversion via embedded zsh script
set rawResult to do shell script "/bin/zsh " & quoted form of scriptPath & " " & quoted form of inputFolder & " " & quoted form of outputFolder

-- Step 6: Parse results
set AppleScript's text item delimiters to "|"
set resultParts to text items of rawResult
set AppleScript's text item delimiters to ""

set convertedCount to (item 1 of resultParts) as integer
set skippedCount to (item 2 of resultParts) as integer
set failedCount to (item 3 of resultParts) as integer
set failedNames to item 4 of resultParts

-- Step 7: Show completion summary
set doneMsg to "🎉  Conversion Complete!" & return & return & "✅  Converted: " & convertedCount & return & "⏭️   Skipped:   " & skippedCount
if failedCount > 0 then
	set doneMsg to doneMsg & return & "❌  Failed:    " & failedCount & return & failedNames
end if

set doneBtn to button returned of (display dialog doneMsg buttons {"Open Output Folder", "Done"} default button "Done" with title "Audio to WAV Converter")

if doneBtn is "Open Output Folder" then
	tell application "Finder"
		open (POSIX file outputFolder as alias)
		activate
	end tell
end if
