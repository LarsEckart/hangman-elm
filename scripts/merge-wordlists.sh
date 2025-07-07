#!/bin/bash

# Merge word lists by language and category, removing difficulty levels

cd src/wordlists

for lang in english german estonian; do
  for cat in animals food sport; do
    output="${lang}-${cat}.csv"
    
    # Check if all three difficulty files exist
    if [ -f "${lang}-${cat}-easy.csv" ] && [ -f "${lang}-${cat}-medium.csv" ] && [ -f "${lang}-${cat}-hard.csv" ]; then
      echo "Merging ${lang}-${cat} files..."
      
      # Combine all three files into one
      cat "${lang}-${cat}-easy.csv" "${lang}-${cat}-medium.csv" "${lang}-${cat}-hard.csv" > "${output}"
      
      # Remove the old difficulty-specific files
      rm "${lang}-${cat}-easy.csv" "${lang}-${cat}-medium.csv" "${lang}-${cat}-hard.csv"
      
      echo "Created ${output} with $(wc -l < "${output}") words"
    else
      echo "Warning: Missing files for ${lang}-${cat}"
    fi
  done
done

echo "Word list reorganization complete!"