#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Mobile-responsive CSS to be injected
const mobileCSS = `
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { 
      padding: 0; 
      margin: 0; 
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }
    
    /* Mobile-first responsive design */
    .app {
      width: 100%;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 10px;
      box-sizing: border-box;
    }
    
    .screen {
      background: white;
      border-radius: 12px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
      padding: 20px;
      max-width: 400px;
      width: 100%;
      margin: 10px;
      box-sizing: border-box;
      text-align: center;
    }
    
    /* Typography */
    .game-title {
      font-size: 2rem;
      font-weight: bold;
      color: #333;
      margin: 0 0 10px 0;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .game-description {
      font-size: 1rem;
      color: #666;
      margin: 0 0 20px 0;
    }
    
    .screen-title {
      font-size: 1.5rem;
      font-weight: bold;
      color: #333;
      margin: 0 0 20px 0;
    }
    
    /* Buttons */
    .start-button, .selection-button, .difficulty-button, .guess-button, .play-again-button, .back-to-start-button {
      background: #667eea;
      color: white;
      border: none;
      border-radius: 8px;
      padding: 12px 24px;
      font-size: 1rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s ease;
      margin: 5px;
      min-height: 48px; /* Touch-friendly minimum height */
      min-width: 120px;
    }
    
    .start-button:hover, .selection-button:hover, .difficulty-button:hover, .guess-button:hover, .play-again-button:hover, .back-to-start-button:hover {
      background: #5a6fd8;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }
    
    .start-button:active, .selection-button:active, .difficulty-button:active, .guess-button:active, .play-again-button:active, .back-to-start-button:active {
      transform: translateY(0);
    }
    
    .start-button:disabled, .selection-button:disabled, .difficulty-button:disabled, .guess-button:disabled, .play-again-button:disabled, .back-to-start-button:disabled {
      background: #ccc;
      cursor: not-allowed;
      transform: none;
    }
    
    /* Button containers */
    .selection-buttons, .difficulty-buttons, .game-over-buttons {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin: 20px 0;
    }
    
    /* Difficulty buttons */
    .difficulty-button {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 16px;
      text-align: center;
    }
    
    .difficulty-button.easy {
      background: #4CAF50;
    }
    
    .difficulty-button.easy:hover {
      background: #45a049;
    }
    
    .difficulty-button.medium {
      background: #FF9800;
    }
    
    .difficulty-button.medium:hover {
      background: #f57c00;
    }
    
    .difficulty-button.hard {
      background: #f44336;
    }
    
    .difficulty-button.hard:hover {
      background: #da190b;
    }
    
    .difficulty-description {
      font-size: 0.8rem;
      margin: 4px 0 0 0;
      opacity: 0.9;
    }
    
    /* Game screen */
    .game-info {
      display: flex;
      justify-content: space-between;
      margin: 20px 0;
      font-size: 0.9rem;
      color: #666;
    }
    
    .word-display {
      margin: 20px 0;
    }
    
    .masked-word {
      font-size: 2rem;
      font-weight: bold;
      color: #333;
      letter-spacing: 0.1em;
      margin: 0;
      font-family: 'Courier New', monospace;
    }
    
    .guessed-letters {
      margin: 20px 0;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }
    
    .guessed-title {
      font-size: 0.9rem;
      color: #666;
      margin: 0 0 5px 0;
    }
    
    .guessed-list {
      font-size: 1rem;
      color: #333;
      margin: 0;
      font-family: 'Courier New', monospace;
    }
    
    .guess-input {
      display: flex;
      flex-direction: column;
      gap: 10px;
      margin: 20px 0;
    }
    
    .letter-input {
      padding: 12px;
      border: 2px solid #ddd;
      border-radius: 8px;
      font-size: 1rem;
      text-align: center;
      outline: none;
      transition: border-color 0.3s ease;
    }
    
    .letter-input:focus {
      border-color: #667eea;
    }
    
    /* Game over screen */
    .game-result {
      margin: 20px 0;
    }
    
    .result-message {
      font-size: 1.5rem;
      font-weight: bold;
      margin: 0 0 20px 0;
    }
    
    .result-message.won {
      color: #4CAF50;
    }
    
    .result-message.lost {
      color: #f44336;
    }
    
    .word-reveal {
      margin: 20px 0;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 8px;
      border: 1px solid #e9ecef;
    }
    
    .word-label {
      font-size: 0.9rem;
      color: #666;
      margin: 0 0 5px 0;
    }
    
    .revealed-word {
      font-size: 1.5rem;
      font-weight: bold;
      color: #333;
      margin: 0;
      font-family: 'Courier New', monospace;
    }
    
    .game-stats {
      margin: 20px 0;
      font-size: 0.9rem;
      color: #666;
    }
    
    .game-stats p {
      margin: 5px 0;
    }
    
    .game-over-buttons {
      flex-direction: row;
      justify-content: center;
      gap: 15px;
    }
    
    /* Error messages */
    .error-message {
      background: #ffebee;
      color: #c62828;
      padding: 10px;
      border-radius: 8px;
      margin: 15px 0;
      border: 1px solid #ffcdd2;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .clear-error-button {
      background: transparent;
      border: none;
      color: #c62828;
      font-size: 1.2rem;
      cursor: pointer;
      padding: 0;
      margin: 0;
      min-height: auto;
      min-width: auto;
    }
    
    .clear-error-button:hover {
      background: rgba(198, 40, 40, 0.1);
      transform: none;
      box-shadow: none;
    }
    
    /* Responsive design */
    @media (max-width: 480px) {
      .app {
        padding: 5px;
      }
      
      .screen {
        margin: 5px;
        padding: 15px;
        border-radius: 8px;
      }
      
      .game-title {
        font-size: 1.5rem;
      }
      
      .screen-title {
        font-size: 1.2rem;
      }
      
      .masked-word {
        font-size: 1.5rem;
      }
      
      .result-message {
        font-size: 1.2rem;
      }
      
      .revealed-word {
        font-size: 1.2rem;
      }
      
      .game-over-buttons {
        flex-direction: column;
        gap: 10px;
      }
      
      .game-info {
        flex-direction: column;
        gap: 5px;
        text-align: center;
      }
    }
    
    /* Accessibility */
    @media (prefers-reduced-motion: reduce) {
      * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
      }
    }
    
    /* Focus styles for keyboard navigation */
    .start-button:focus, .selection-button:focus, .difficulty-button:focus, .guess-button:focus, .play-again-button:focus, .back-to-start-button:focus {
      outline: 2px solid #667eea;
      outline-offset: 2px;
    }
    
    .letter-input:focus {
      outline: 2px solid #667eea;
      outline-offset: 2px;
    }
    
    /* Touch improvements */
    @media (hover: none) {
      .start-button:hover, .selection-button:hover, .difficulty-button:hover, .guess-button:hover, .play-again-button:hover, .back-to-start-button:hover {
        transform: none;
        box-shadow: none;
      }
    }
  </style>
`;

// Read the compiled HTML file
const htmlFilePath = path.join(__dirname, '..', 'dist', 'index.html');

try {
  let htmlContent = fs.readFileSync(htmlFilePath, 'utf8');
  
  // Replace the basic styles with mobile-responsive styles
  htmlContent = htmlContent.replace(
    '<style>body { padding: 0; margin: 0; }</style>',
    mobileCSS
  );
  
  // Update the title
  htmlContent = htmlContent.replace(
    '<title>Main</title>',
    '<title>Hangman Game - Multi-language Word Guessing Game</title>'
  );
  
  // Write the updated HTML back to file
  fs.writeFileSync(htmlFilePath, htmlContent);
  
  console.log('✅ Mobile-responsive CSS has been injected into dist/index.html');
  console.log('📱 The app now includes:');
  console.log('   - Mobile-first responsive design');
  console.log('   - Touch-friendly buttons (minimum 48px height)');
  console.log('   - Flexible layouts for small screens');
  console.log('   - Proper viewport meta tag');
  console.log('   - Accessibility improvements');
  console.log('   - Modern UI with gradients and shadows');
  
} catch (error) {
  console.error('❌ Error processing HTML file:', error.message);
  process.exit(1);
}