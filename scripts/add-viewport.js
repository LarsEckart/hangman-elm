#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, '..', 'dist', 'index.html');

console.log('Adding viewport meta tag and service worker to generated HTML...');

try {
  // Read the generated HTML file
  const htmlContent = fs.readFileSync(htmlPath, 'utf8');
  
  // Service Worker registration script
  const serviceWorkerScript = `
<script>
// Register Service Worker for offline functionality
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function() {
    navigator.serviceWorker.register('/sw.js')
      .then(function(registration) {
        console.log('Service Worker registered with scope:', registration.scope);
      })
      .catch(function(error) {
        console.log('Service Worker registration failed:', error);
      });
  });
}
</script>`;
  
  // Find the charset meta tag and add viewport after it
  const updatedContent = htmlContent
    .replace(
      /<meta charset="UTF-8">/,
      '<meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    )
    .replace(
      /<title>Main<\/title>/,
      '<title>Hangman Game</title>'
    )
    .replace(
      /<\/head>/,
      `${serviceWorkerScript}\n</head>`
    );
  
  // Write the updated HTML back
  fs.writeFileSync(htmlPath, updatedContent);
  
  console.log('✓ Viewport meta tag added successfully');
  console.log('✓ Title updated to "Hangman Game"');
  console.log('✓ Service Worker registration added');
  
} catch (error) {
  console.error('Error updating HTML:', error.message);
  process.exit(1);
}