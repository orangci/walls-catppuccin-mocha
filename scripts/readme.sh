#!/usr/bin/env bash
commit_msg="$1"

# Function to generate the markdown file
generate_markdown() {
    local image_folder="$1"
    local output_file="$2"
    local repo_url="$3"
    local header="$4"
    local description="$5"
    local disclaimer="$6"

    # Create or clear the output file
    echo "$header" > $output_file
    echo "$description" >> $output_file
    echo "" >> $output_file
    echo "$disclaimer" >> $output_file
    echo "# Preview" >> $output_file

    # Add table header
    echo "| Column 1 | Column 2 | Column 3 | Column 4 |" >> $output_file
    echo "|---------|---------|---------|---------|" >> $output_file

    # Initialize a counter for images
    counter=0
    row=""

    # Loop through all image files in the folder
    shopt -s nullglob
    for image in "$image_folder"/*.{jpg,jpeg,png,gif}; do
        if [[ -f $image ]]; then
            # Extract the file name from the path
            filename=$(basename "$image")
            # Construct the URL
            url="$repo_url/$filename"
            # Append the markdown for the image to the row
            row="$row| ![${filename}](${url}) "
            # Increment the counter
            ((counter++))
            # If counter is 4, reset the counter and append the row to the output file
            if [[ $counter -eq 4 ]]; then
                echo "$row|" >> $output_file
                row=""
                counter=0
            fi
        fi
    done

    # If there are remaining images in the row, fill the rest of the row with empty cells
    if [[ $counter -ne 0 ]]; then
        while [[ $counter -lt 4 ]]; do
            row="$row| "
            ((counter++))
        done
        echo "$row|" >> $output_file
    fi

    echo "Markdown file '$output_file' generated successfully."
}

# Function to commit and push changes to git
commit_and_push() {
    local image_folder="$1"
    
    cd $image_folder
    git add .
    git commit -m "$commit_msg"
    git push
    cd ..
}

# Variables
base_url="https://raw.githubusercontent.com/orangci"
header_normal="# orangc's walls"
description_normal="Hi! This is my repository of wallpapers which I've collected over the years. A catppuccin-mocha version is available [here](https://github.com/orangci/walls-catppuccin-mocha)."
disclaimer_normal="> Disclaimer: These wallpapers are sourced from many, many, many sources on the internet. I did not make any of these, although I have *edited* several of them a little bit. Zero credit belongs to me in that regard, I'm simply the collector. If you are the artist of one of these wallpapers, please [**contact me**](https://orangc.net), I will happily take the wallpaper down or add credit in this README."

header_catppuccin="# orangc's walls, catppuccin-mocha edition"
description_catppuccin="Hi! This is my repository of wallpapers which I've collected over the years. This is the catppuccin-mocha version; the normal repo is available [here](https://github.com/orangci/walls)."
disclaimer_catppuccin="> Disclaimer: These wallpapers are sourced from many, many, many sources on the internet. I did not make any of these, although I have *edited* several of them a little bit and use lutgen to convert them from their normal versions in orangci/walls to the catppuccin-mocha colour scheme. Zero credit belongs to me in that regard, I'm simply the collector. If you are the artist of one of these wallpapers, please [**contact me**](https://orangc.net), I will happily take the wallpaper down or add credit in this README."

header_aniwalls="# orangc's anime walls"
description_aniwalls="Hi! This is my repository of anime wallpapers which I've collected over the years. Looking for something that doesn't scream \"I'M A WEEEEEB?\" My main collection doesn't have any women in it: [orangci/walls](https://github.com/orangci/walls)."
disclaimer_aniwalls="> Disclaimer: These wallpapers are sourced from many, many, many sources on the internet. I did not make any of these, although I have *slightly edited* several of them a little bit. Zero credit belongs to me in that regard, I'm simply the collector. If you are the artist of one of these wallpapers, please [**contact me**](https://orangc.net), I will happily take the wallpaper down or add credit in this README."

# Generate markdown and commit for normal walls
generate_markdown "$HOME/media/walls" "walls/README.md" "$base_url/walls/main" "$header_normal" "$description_normal" "$disclaimer_normal"
commit_and_push "$HOME/media/walls"

# Generate markdown and commit for catppuccin walls
generate_markdown "$HOME/media/walls-catppuccin-mocha" "walls-catppuccin-mocha/README.md" "$base_url/walls-catppuccin-mocha/master" "$header_catppuccin" "$description_catppuccin" "$disclaimer_catppuccin"
commit_and_push "$HOME/media/walls-catppuccin-mocha"

# Generate markdown and commit for aniwalls
generate_markdown "$HOME/media/aniwalls" "aniwalls/README.md" "$base_url/aniwalls/main" "$header_aniwalls" "$description_aniwalls" "$disclaimer_aniwalls"
commit_and_push "$HOME/media/aniwalls"