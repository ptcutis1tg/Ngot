# Supabase Password Reset & go_router Integration

## Goal
Implement a robust deep linking flow for Supabase password recovery using a custom URL scheme and refactor the app's navigation to use `go_router` to handle routing state efficiently.

## Architecture & Navigation
We will replace the basic `MaterialApp(home: ...)` structure with `MaterialApp.router` using the `go_router` package.

### Routes Configuration
1. **`/` (Root/Launch Gate)**:
   - Evaluates whether the user has completed onboarding and whether they are logged in.
   - Redirects to `/home` if logged in and onboarding is completed.
2. **`/home`**:
   - The main application screen (`MainNavigationScreen`).
3. **`/update-password`**:
   - A dedicated screen for the user to input and submit a new password.

### Auth State Listener
- Implement a `RouterNotifier` (or similar stream subscription mechanism) that listens to `Supabase.instance.client.auth.onAuthStateChange`.
- If the event is `AuthChangeEvent.passwordRecovery`, the router will automatically redirect the user to `/update-password`.
- If the event is `AuthChangeEvent.signedOut`, the router redirects to `/`.

## Custom URL Scheme Configuration
### Android
Update `android/app/src/main/AndroidManifest.xml` to include an intent filter for the scheme `ngotapp://`.

### iOS
Update `ios/Runner/Info.plist` to register the `ngotapp` URL scheme.

### Supabase Configuration
- The Supabase project dashboard must be configured to allow `ngotapp://login-callback` as a valid Redirect URL.

## User Flow
1. User requests a password reset from the Auth screen.
2. Supabase sends an email containing a link with the custom scheme (e.g., `ngotapp://login-callback#access_token=...`).
3. User taps the link; the OS opens the application.
4. `supabase_flutter` intercepts the link, parses the token, and emits a `passwordRecovery` event.
5. The global router listener detects the event and redirects the user to `/update-password`.
6. User enters their new password and submits.
7. Upon success, the app updates the password via Supabase and redirects the user to `/home`.

## Dependencies
- `go_router`: For declarative routing and deep link handling.
- `supabase_flutter`: Existing dependency, used for handling auth events.
