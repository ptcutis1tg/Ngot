# Specification: Profile Settings Update

Implement a more interactive and visually rich profile management flow in the Settings screen. This specification defines how the settings header and personal information screen will be updated.

## User Review Required

> [!NOTE]
> The registered email address will remain read-only on the Personal Information screen and will only be displayed as reference, synced with Supabase authentication.

## Proposed Changes

### Settings Screen Component

#### [MODIFY] [settings_sections.dart](file:///d:/Ngot/lib/firstscreen/settings_components/settings_sections.dart)
- Wrap the `ProfileHeader` container with an `InkWell` (with appropriate hover and tap ripple effects) that navigates to the `PersonalInformationScreen` when tapped.
- Display the registered email from the auth provider or local settings.
- Add a camera edit badge overlay (green circle background with edit/camera icon) on the bottom-right of the `CircleAvatar` in the `ProfileHeader` to indicate it is interactive.

---

### Personal Information Screen

#### [MODIFY] [personal_information_screen.dart](file:///d:/Ngot/lib/firstscreen/personal_information_screen.dart)
- Keep the email address read-only under the system information section.
- Ensure the user's display username and avatar are editable and sync correctly with the `UserProfileProvider`.
- Improve visual coherence of the screen to align with the rest of the application's green-themed dark/light color palette.

---

### User Profile Provider

#### [MODIFY] [userprofileprovider.dart](file:///d:/Ngot/lib/providers/userprofileprovider.dart)
- Ensure email and username synchronizations are correct when auth state changes (already partly done in `main.dart` with `onAuthStateChange`).
- Keep local persistence via `SharedPreferences`.

## Verification Plan

### Manual Verification
- Launch the application and navigate to Settings.
- Verify that the profile header is interactive (has ripple effects, click feedback) and displays the user's name and email.
- Click on the profile header or avatar. Verify it navigates to the `PersonalInformationScreen`.
- Change the avatar and the username, save the changes, and verify that the settings profile header updates immediately.
- Verify that the email is displayed and read-only.
