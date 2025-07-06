#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, '..', 'dist', 'index.html');

console.log('Adding viewport meta tag to generated HTML...');

try {
  // Read the generated HTML file
  const htmlContent = fs.readFileSync(htmlPath, 'utf8');
  
  // Find the charset meta tag and add viewport after it
  const updatedContent = htmlContent
    .replace(
      /<meta charset="UTF-8">/,
      '<meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    )
    .replace(
      /<title>Main<\/title>/,
      '<title>Hangman Game</title>'
    );
  
  // Write the updated HTML back
  fs.writeFileSync(htmlPath, updatedContent);
  
  console.log('✓ Viewport meta tag added successfully');
  console.log('✓ Title updated to "Hangman Game"');
  
} catch (error) {
  console.error('Error adding viewport meta tag:', error.message);
  process.exit(1);
}