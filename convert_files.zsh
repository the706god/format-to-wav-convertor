#!/bin/zsh
# convert_files.zsh — called by Audio to WAV Converter.app
# Usage: convert_files.zsh <input_dir> <output_dir>

INPUT="$1"
OUTPUT="$2"

mkdir -p "$OUTPUT"

converted=0
skipped=0
failed=0
failed_names=""

if command -v ffmpeg >/dev/null 2>&1; then
    engine="ffmpeg"
else
    engine="afconvert"
fi

while IFS= read -r -d '' f; do
    base="${f:t}"
    name="${base:r}"
    out="$OUTPUT/$name.wav"

    if [[ -f "$out" ]]; then
        skipped=$((skipped + 1))
        continue
    fi

    if [[ "$engine" == "ffmpeg" ]]; then
        ffmpeg -y -loglevel error -i "$f" "$out" >/dev/null 2>&1
    else
        afconvert -f WAVE -d LEI16 "$f" "$out" >/dev/null 2>&1
    fi

    if [[ $? -eq 0 ]]; then
        converted=$((converted + 1))
    else
        failed=$((failed + 1))
        failed_names="$failed_names $base"
    fi
done < <(find "$INPUT" -maxdepth 1 -type f \( \
    -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.aac" \
    -o -iname "*.aiff" -o -iname "*.aif" -o -iname "*.flac" \
    -o -iname "*.caf" -o -iname "*.caff" \
    -o -iname "*.m4p" -o -iname "*.m4r" -o -iname "*.mp4" \
\) -print0)

echo "${converted}|${skipped}|${failed}|${failed_names}"
