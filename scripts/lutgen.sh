#!/usr/bin/env bash

cd $HOME/media/temp || exit

for img in $HOME/media/temp/*; do
    lutgen apply $img -p catppuccin-mocha
done

echo ""
echo "Finished applying catppuccin with lutgen."
echo ""

mkdir catppuccin
echo "Created temporary catppuccin folder."

mv *_catppuccin-mocha.* catppuccin
cd catppuccin
for file in *_catppuccin-mocha.*; do
  [ -e "$file" ] || continue
  new_name="${file/_catppuccin-mocha/}"
  mv -- "$file" "$new_name"
done

echo "Finished renaming images."

mv * $HOME/media/walls-catppuccin-mocha

echo "Finished moving catppuccinified images to walls-catppuccin-mocha."

cd ..
rm -rf catppuccin
echo "Deleted temporary catppuccin folder."

mv * $HOME/media/walls
echo "Finished moving images to walls."