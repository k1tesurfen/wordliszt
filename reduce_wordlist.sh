#!/usr/bin/env bash

# Usage:
#   ./sort_wordlist.sh input_huge_wordlist.txt

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_wordlist.txt>"
  exit 1
fi

INPUT="$1"
# Base name for the output files
PREFIX="wordlist"

# Force UTF-8 locale for character-aware counting (Umlaut safe!)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo "Cleaning carriage returns and preparing the huge list..."
# Create a temporary file to hold the cleaned list for faster processing
CLEANED_INPUT=$(mktemp)
tr -d '\r' <"$INPUT" >"$CLEANED_INPUT"

# The character lengths we want to target
LENGTHS=(3 4 6 8)

echo "Generating specific wordlists..."

# Loop through each length and generate the required files
for LEN in "${LENGTHS[@]}"; do

  # 1. Generate EXACT length list (e.g., exact 8 characters)
  EXACT_OUT="${PREFIX}_exact_${LEN}_char.txt"
  grep -xE ".{${LEN}}" "$CLEANED_INPUT" >"$EXACT_OUT"
  echo " -> Created: $EXACT_OUT"

  # 2. Generate MAX length list (e.g., 1 to 8 characters)
  MAX_OUT="${PREFIX}_max_${LEN}_char.txt"
  grep -xE ".{1,${LEN}}" "$CLEANED_INPUT" >"$MAX_OUT"
  echo " -> Created: $MAX_OUT"

done

# Clean up the temporary file
rm "$CLEANED_INPUT"

echo "Done! All wordlists have been generated perfectly."
