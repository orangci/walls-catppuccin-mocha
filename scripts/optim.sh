#!/usr/bin/env bash

# -------------------------------------
# -- THIS SCRIPT HAS NOT BEEN TESTED --
# -------------------------------------

# nix-shell -p optipng jpegoptim 

# Folder to process (default to current directory if none provided)
target_dir="${1:-.}"

# Create output folder to avoid overwriting original files
output_dir="${target_dir%/}-optimized"
mkdir -p "$output_dir"

# Process images
find "$target_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) | while read -r img; do
    filename=$(basename "$img")
    extension="${filename##*.}"
    output_file="$output_dir/${filename%.*}.png"

    echo "Processing: $filename"

    case "$extension" in
        png)
            # Optimize PNG with a 45-second timeout
            if ! timeout 45s optipng -o7 -strip all -out "$output_file" "$img"; then
                echo "Timeout on $filename, copying original."
                cp "$img" "$output_file"
            fi
            ;;
        jpg|jpeg)
            # Optimize JPEG and convert to PNG with a 45-second timeout
            if ! timeout 45s bash -c "jpegoptim --strip-all --all-progressive '$img' && magick '$img' -strip '$output_file'"; then
                echo "Timeout on $filename, copying original."
                cp "$img" "$output_file"
            fi
            ;;
        gif)
            # Just copy GIFs as they are
            cp "$img" "$output_dir/$filename"
            ;;
    esac

    echo "Optimized: $output_file"
done

echo "All images processed. Optimized versions are in: $output_dir"
