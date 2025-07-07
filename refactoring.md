# Code Cleanup Refactoring Prompt

## Dead Code Cleanup

Review the codebase for unused/dead code and clean it up. Run tests to verify everything still works, commit, bump patch level and push.

### Instructions:

1. **Search for unused code**:
   - Look for unused imports, functions, constants, and files
   - Check for dead code that's no longer referenced
   - Identify redundant or obsolete modules

2. **Verify it's truly unused**:
   - Search entire codebase for references
   - Check if code is used in tests, build scripts, or configuration
   - **Note**: Functions only called from test code should also be considered unused from the product perspective and can be removed
   - Ensure removal won't break functionality

3. **Clean up systematically**:
   - Remove unused imports first
   - Delete unused functions and constants
   - Remove entire unused files if safe
   - Clean up any related documentation

4. **Verify integrity**:
   - Run full test suite to ensure no breakage
   - Check that build process still works
   - Verify application still functions correctly

5. **Document and commit**:
   - Write clear commit message explaining what was removed and why
   - Bump patch version (this is maintenance, not new features)
   - Push changes to repository

### Expected outcome:
- Cleaner, more maintainable codebase
- Reduced bundle size and complexity
- No functional changes to the application
- All tests passing
- Version bumped appropriately