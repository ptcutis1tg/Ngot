# Specification: Static Header and Email Sync

Modify the Settings ProfileHeader to be static (not clickable, no camera overlay) and implement automated email synchronization with Supabase registration/login.

## Proposed Changes

### Settings Screen Component

#### [MODIFY] [settings_sections.dart](file:///d:/Ngot/lib/firstscreen/settings_components/settings_sections.dart)
- Revert the `ProfileHeader` to a static Container.
- Remove the `InkWell` wrapper and its `onTap` callback.
- Remove the camera badge overlay `Stack` from `CircleAvatar` so it displays a static avatar image.

---

### Onboarding Flow Component

#### [MODIFY] [onboarding_flow.dart](file:///d:/Ngot/lib/firstscreen/onboarding_flow.dart)
- Import `userprofileprovider.dart`.
- In `AppLaunchGateState`:
  - Listen to `Supabase.instance.client.auth.onAuthStateChange`.
  - When `AuthState` has a session/user, update `UserProfileProvider` with the user's email and initial username.
- In `_handleSupabaseAuth()` under the sign-up block, immediately update `UserProfileProvider` with the registered email.

## Verification Plan

### Manual Verification
- Navigate to the Settings screen and verify that clicking the ProfileHeader card does not navigate anywhere and has no touch ripple effect.
- Verify that there is no camera badge overlay on the avatar.
- Sign up with a new email address via the Onboarding Flow. Verify that after registration, the email address is immediately displayed on the settings screen header.
