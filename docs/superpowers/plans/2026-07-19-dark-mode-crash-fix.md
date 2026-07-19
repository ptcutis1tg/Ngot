# Dark Mode Toggle Crash Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the Flutter Red Screen of Death crash that occurs when toggling dark mode by making the `TextTheme` structures for light and dark modes perfectly symmetric.

**Architecture:** Use `ThemeData.light().textTheme` and `ThemeData.dark().textTheme` inside `GoogleFonts.interTextTheme()` without using the `.apply()` method, preventing the `inherit` property mismatch during animation interpolation.

**Tech Stack:** Flutter, Dart, Google Fonts

## Global Constraints
- Run the application and navigate to Settings.
- Toggle the Dark Mode switch back and forth.
- Verify that the transition is completely smooth and no crashes or exceptions are logged to the console.
- Ensure the text colors remain correct (dark text on light theme, white text on dark theme).

---

### Task 1: Update ThemeData in main.dart

**Files:**
- Modify: `lib/main.dart`

**Interfaces:**
- Consumes: `ThemeData.light()` and `ThemeData.dark()`
- Produces: Correctly inherited `TextTheme` for both light and dark modes

- [ ] **Step 1: Run existing tests to verify baseline**

```bash
flutter test
```
Expected: PASS (The existing tests should pass, the crash is a runtime animation issue)

- [ ] **Step 2: Update the Light Theme TextTheme**

In `lib/main.dart`, locate the `theme: ThemeData(` block. Find the `textTheme` assignment.
Replace:
```dart
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
```
With:
```dart
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
```

- [ ] **Step 3: Update the Dark Theme TextTheme**

In `lib/main.dart`, locate the `darkTheme: ThemeData(` block. Find the `textTheme` assignment.
Replace:
```dart
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
```
With:
```dart
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
```

- [ ] **Step 4: Verify the build and tests**

```bash
flutter test
```
Expected: PASS (Ensure no syntax errors were introduced)

- [ ] **Step 5: Commit**

```bash
git add lib/main.dart
git commit -m "fix: resolve dark mode toggle crash by syncing text theme inherit properties"
```
