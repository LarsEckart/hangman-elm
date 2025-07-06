# Build-Time Word List Loading Implementation Plan

## Overview
Transform the current runtime CSV file loading system into a build-time word list compilation system. This will eliminate HTTP requests, improve performance, and make the app fully self-contained.

## Current State Analysis (Updated 2025-07-06)

### ✅ **Fully Implemented Features**
- **Complete UI Architecture**: 6-screen flow (Start → Language → Category → Difficulty → Game → GameOver)
- **Multi-Language Support**: English, German, Estonian with 12 CSV files
- **Category System**: Animals, Food, Sport categories per language
- **Difficulty Levels**: Easy, Medium, Hard with length-based validation
- **Dual Word Loading**: HTTP CSV loading + embedded fallback in `Words.elm`
- **Game Logic**: Complete pure functions in `GameLogic.elm` with 157 tests
- **Type System**: Comprehensive types in `Types.elm` with helper functions
- **Error Handling**: HTTP failure handling with graceful fallbacks

### ✅ **Current Modules**
- `Main.elm`: Full Browser.element app with Model-View-Update pattern
- `Types.elm`: Language/Category/Difficulty types + 12-field Model
- `GameLogic.elm`: Pure game functions (tested, working)
- `WordLoader.elm`: HTTP CSV loading with dynamic path generation
- `Words.elm`: Embedded fallback word lists (English only)
- `tests/GameLogicTest.elm`: 157 comprehensive tests (passing)
- `tests/WordsTest.elm`: 27 tests for embedded lists (passing)
- `tests/UpdateTest.elm`: Update function tests (⚠️ currently failing)

### ❌ **Current Limitations**
- Requires web server for CSV file serving (`elm reactor` or Python server)
- Network dependency for primary word loading mechanism
- Not self-contained (needs `src/wordlists/*.csv` files served)
- Potential CORS issues in production deployments
- Test failures in `UpdateTest.elm` need resolution

## Target State
- ✅ All word lists embedded in compiled Elm code
- ✅ Zero network requests for word loading
- ✅ Instant word loading (no async operations)
- ✅ Self-contained HTML file
- ✅ Maintains language/category/difficulty flexibility

---

## Phase 0: Prerequisites and Test Fixes
**Goal**: Stabilize existing codebase before implementing build-time embedding

### Step 0.1: Fix Failing Tests
- [ ] Debug and fix `UpdateTest.elm` type mismatches
- [ ] Ensure all existing tests pass before proceeding
- [ ] Verify test infrastructure is working correctly

### Step 0.2: Code Quality Validation
- [ ] Run `elm-test` to confirm all tests pass
- [ ] Check for any compiler warnings or errors
- [ ] Validate current CSV file structure and content

### Step 0.3: Baseline Documentation
- [ ] Document current architecture in CLAUDE.md
- [ ] Record current file structure and dependencies
- [ ] Establish performance baseline measurements

---

## Phase 1: Build Script Development
**Goal**: Create Node.js build script to process CSV files and generate Elm code

### Step 1.1: Create CSV Reader Script
- [ ] Create `scripts/build-wordlists.js`
- [ ] Implement CSV file discovery in `src/wordlists/` (12 existing files)
- [ ] Parse CSV files into structured data (simple format: one word per line)
- [ ] Validate word lists (length requirements per difficulty: Easy 3-5, Medium 6-8, Hard 9+)
- [ ] Handle missing CSV files gracefully with warnings

### Step 1.2: Elm Code Generation
- [ ] Generate optimized lookup structure for 3-dimensional access (Language → Category → Difficulty)
- [ ] Create `getWordList : Language -> Category -> Difficulty -> List String` function
- [ ] Generate fallback handling for missing combinations
- [ ] Output to `src/Generated/WordLists.elm` with proper imports
- [ ] Ensure generated code passes `elm make` compilation
- [ ] Include word count validation in generated code

### Step 1.3: Build Integration
- [ ] Add npm scripts for build process
- [ ] Integrate with existing compilation workflow
- [ ] Add generated files to `.gitignore`

---

## Phase 2: Feature Flag Implementation
**Goal**: Add toggle between HTTP and embedded word lists for safe migration

### Step 2.1: Add Feature Flag System
- [ ] Add `useEmbeddedWordLists : Bool` flag to Model
- [ ] Create configuration system for build-time vs runtime loading
- [ ] Add UI toggle for testing both systems (development only)

### Step 2.2: Implement Embedded Word Loading Path
- [ ] Import `Generated.WordLists` module in Main.elm
- [ ] Create `loadEmbeddedWords` function for immediate word selection
- [ ] Update `SelectDifficulty` message to handle both paths
- [ ] Maintain existing HTTP path as fallback

### Step 2.3: Parallel System Validation
- [ ] Add validation that both systems return equivalent results
- [ ] Create development mode comparison testing
- [ ] Ensure random seed consistency between systems

---

## Phase 3: Full Migration to Embedded System
**Goal**: Complete transition to embedded word lists and remove HTTP dependencies

### Step 3.1: Production Flag Switch
- [ ] Set `useEmbeddedWordLists = True` as default
- [ ] Remove development UI toggle
- [ ] Validate all 27 language/category/difficulty combinations work

### Step 3.2: HTTP System Removal
- [ ] Remove `WordLoader.elm` module
- [ ] Remove `Http` imports from `Main.elm` and `Types.elm`
- [ ] Remove `LoadWordList` message and HTTP error handling
- [ ] Remove `wordList` field from Model (replaced by immediate lookup)

### Step 3.3: Code Simplification
- [ ] Simplify message flow (no async word loading)
- [ ] Update `SelectDifficulty` handler for immediate word selection
- [ ] Remove HTTP-related error states and loading indicators
- [ ] Update `Words.elm` to use generated lists or remove entirely

---

## Phase 4: Build Process Automation
**Goal**: Streamline the development and build workflow

### Step 4.1: Development Scripts
- [ ] `npm run build-wordlists` - Generate word lists
- [ ] `npm run dev` - Build wordlists + elm reactor
- [ ] `npm run build` - Full production build

### Step 4.2: Watch Mode (Optional)
- [ ] Auto-regenerate on CSV file changes
- [ ] Integrate with development workflow
- [ ] Hot reload support

### Step 4.3: Documentation
- [ ] Update README with new build process
- [ ] Document CSV file format requirements
- [ ] Add troubleshooting guide

---

## Phase 5: Testing and Validation
**Goal**: Ensure reliability and maintain test coverage

### Step 5.1: Generated Code Testing
- [ ] Unit tests for word list lookup functions
- [ ] Validate generated Elm code syntax
- [ ] Test edge cases (empty lists, missing files)

### Step 5.2: Integration Testing
- [ ] Test complete game flow with generated word lists
- [ ] Verify all language/category combinations
- [ ] Performance testing (load times, memory usage)

### Step 5.3: Regression Testing
- [ ] Ensure existing game logic still works
- [ ] Verify randomization quality
- [ ] Test UI responsiveness

---

## Phase 6: Cleanup and Optimization
**Goal**: Remove legacy code and optimize the implementation

### Step 6.1: Legacy Code Removal
- [ ] Remove CSV files from `src/wordlists/` (move to `data/`)
- [ ] Clean up unused imports and functions
- [ ] Remove HTTP-related error handling

### Step 6.2: Performance Optimization
- [ ] Optimize generated code size
- [ ] Consider word list compression techniques
- [ ] Bundle size analysis

### Step 6.3: Final Documentation
- [ ] Complete README update
- [ ] Add build process documentation
- [ ] Update CLAUDE.md with new architecture

---

## Implementation Details

### Generated Elm Module Structure (Updated)
```elm
module Generated.WordLists exposing (..)

import Dict exposing (Dict)
import Types exposing (Language(..), Category(..), Difficulty(..))

-- Optimized 3-dimensional lookup structure
type alias WordListDB = Dict String (Dict String (Dict String (List String)))

-- Generated word database: language -> category -> difficulty -> word list
wordListDB : WordListDB

-- Primary lookup function
getWordList : Language -> Category -> Difficulty -> List String

-- Helper functions for key generation
languageToString : Language -> String
categoryToString : Category -> String
difficultyToString : Difficulty -> String

-- Fallback and validation
getAvailableCombinations : List (Language, Category, Difficulty)
validateWordList : List String -> Difficulty -> Bool
```

### Build Script Output Example (Updated)
```elm
-- Generated by build-wordlists.js on 2025-07-06
-- Do not edit manually - regenerate with: npm run build-wordlists

module Generated.WordLists exposing (..)

import Dict exposing (Dict)
import Types exposing (Language(..), Category(..), Difficulty(..))

-- 3-dimensional nested Dict structure for efficient lookup
wordListDB : Dict String (Dict String (Dict String (List String)))
wordListDB = 
    Dict.fromList
        [ ("english", Dict.fromList
            [ ("animals", Dict.fromList
                [ ("easy", ["cat", "dog", "pig", "cow", "hen"])
                , ("medium", ["rabbit", "turtle", "chicken"])
                , ("hard", ["elephant", "kangaroo", "rhinoceros"])
                ])
            , ("food", Dict.fromList [...])
            , ("sport", Dict.fromList [...])
            ])
        , ("german", Dict.fromList [...])
        , ("estonian", Dict.fromList [...])
        ]

getWordList : Language -> Category -> Difficulty -> List String
getWordList language category difficulty =
    wordListDB
        |> Dict.get (languageToString language)
        |> Maybe.andThen (Dict.get (categoryToString category))
        |> Maybe.andThen (Dict.get (difficultyToString difficulty))
        |> Maybe.withDefault []
```

### Package.json Scripts
```json
{
  "scripts": {
    "build-wordlists": "node scripts/build-wordlists.js",
    "dev": "npm run build-wordlists && elm reactor",
    "build": "npm run build-wordlists && elm make src/Main.elm --output=dist/index.html",
    "watch": "nodemon --watch src/wordlists --exec 'npm run build-wordlists'"
  }
}
```

---

## Benefits of This Approach

### Performance Benefits
- ✅ Zero network requests for word loading
- ✅ Instant word availability
- ✅ No loading states or error handling needed
- ✅ Smaller runtime complexity

### Development Benefits  
- ✅ Self-contained builds
- ✅ No web server required for development
- ✅ Easier deployment (single HTML file)
- ✅ No CORS issues

### Maintenance Benefits
- ✅ Build-time validation of word lists
- ✅ Type-safe word list access
- ✅ Centralized word list management
- ✅ Easy to add new languages/categories

---

## Migration Strategy (Updated)

1. **Prerequisite Phase**: Fix failing tests and establish stable baseline
2. **Build Infrastructure**: Create generation scripts and validate output
3. **Feature Flag Implementation**: Add parallel systems with toggle capability
4. **Validation Phase**: Ensure feature parity between HTTP and embedded systems
5. **Production Switch**: Default to embedded with HTTP fallback
6. **Legacy Removal**: Remove HTTP code after confidence period
7. **Optimization**: Code cleanup and performance improvements

### Risk Mitigation
- **Rollback capability**: Keep HTTP system until embedded is proven
- **Gradual deployment**: Feature flag allows safe testing
- **Validation**: Compare outputs between systems during transition
- **Test coverage**: Maintain comprehensive test suite throughout migration

---

## File Structure After Implementation

```
hangman-elm/
├── src/
│   ├── Main.elm              # Updated for embedded word lists (no HTTP imports)
│   ├── Types.elm             # Simplified (removed HTTP-related types)
│   ├── GameLogic.elm         # Unchanged (pure functions)
│   ├── Words.elm             # Removed or updated to use Generated module
│   ├── wordlists/            # Original CSV files (12 files)
│   │   ├── english-animals-easy.csv
│   │   ├── english-animals-medium.csv
│   │   ├── english-animals-hard.csv
│   │   ├── german-animals-easy.csv
│   │   ├── estonian-animals-easy.csv
│   │   └── ... (7 more CSV files)
│   └── Generated/            # Auto-generated (gitignored)
│       └── WordLists.elm     # Generated word lists module
├── tests/
│   ├── GameLogicTest.elm     # Existing (157 tests)
│   ├── WordsTest.elm         # Existing (27 tests)
│   ├── UpdateTest.elm        # Fixed and updated
│   └── GeneratedWordListsTest.elm # New tests for generated module
├── scripts/
│   └── build-wordlists.js    # Build script
├── package.json              # Updated with build scripts
├── elm.json                  # Removed elm/http dependency
├── .gitignore                # Added src/Generated/
└── CLAUDE.md                 # Updated with new architecture
```

---

## Success Criteria (Updated)

### **Primary Goals**
- [ ] All 12 CSV word lists embedded at build time
- [ ] Zero HTTP requests during gameplay (fully self-contained)
- [ ] Maintains complete language/category/difficulty functionality (3×3×3 = 27 combinations)
- [ ] Self-contained HTML output (works without web server)
- [ ] All existing tests pass (157 GameLogic + 27 Words + fixed Update tests)

### **Quality Assurance**
- [ ] Build process integrated into development workflow
- [ ] Generated code passes elm-make compilation
- [ ] Performance maintained or improved (instant word loading)
- [ ] Word length validation preserved for all difficulty levels
- [ ] Random word selection quality maintained

### **Development Experience**
- [ ] `npm run dev` builds word lists + starts elm reactor
- [ ] `npm run build` creates production-ready self-contained HTML
- [ ] Documentation updated in CLAUDE.md and README
- [ ] Clear rollback path if issues arise

### **Validation Criteria**
- [ ] All 27 language/category/difficulty combinations tested
- [ ] Generated word lists match CSV file contents exactly
- [ ] Game behavior identical between HTTP and embedded systems
- [ ] Build process handles missing CSV files gracefully