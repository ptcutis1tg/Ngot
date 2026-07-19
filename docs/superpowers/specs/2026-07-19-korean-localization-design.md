# Specification: Korean Localization Support

Add Korean language support to the application and ensure that all UI text dynamically updates when the user switches their preferred language.

## Proposed Changes

### Translations Map

#### [NEW] [app_translations.dart](file:///d:/Ngot/lib/providers/app_translations.dart)
- Managed in a centralized `AppTranslations` class containing translations for English (`en`), Vietnamese (`vi`), and Korean (`ko`).

---

### App Settings Provider

#### [MODIFY] [app_settings_provider.dart](file:///d:/Ngot/lib/providers/app_settings_provider.dart)
- Add `'ko'` to the list of accepted language codes in `setLanguageCode`.

---

### main.dart Configuration

#### [MODIFY] [main.dart](file:///d:/Ngot/lib/main.dart)
- Add `Locale('ko')` to `supportedLocales` in the `MaterialApp.router`.
- Use `AppTranslations` to translate the bottom navigation bar labels.

---

### Onboarding Flow

#### [MODIFY] [onboarding_flow.dart](file:///d:/Ngot/lib/firstscreen/onboarding_flow.dart)
- Add a RadioListTile for Korean (`한국어`) to the onboarding language step.
- Translate all onboarding onboarding texts, intro panels, and auth widgets.

---

### Settings & Profile Screen

#### [MODIFY] [settings_screen.dart](file:///d:/Ngot/lib/firstscreen/settings_screen.dart)
- Add Korean to the language picker dialog list.
- Use `AppTranslations` to translate all titles, notifications, confirmation dialogs, and descriptions.

#### [MODIFY] [settings_sections.dart](file:///d:/Ngot/lib/firstscreen/settings_components/settings_sections.dart)
- Use `AppTranslations` to translate section headers, functional tile titles, buttons, and trailing text status descriptions.

#### [MODIFY] [personal_information_screen.dart](file:///d:/Ngot/lib/firstscreen/personal_information_screen.dart)
- Use `AppTranslations` to translate form headers, labels, placeholders, input validations, system information fields, and status feedback snackbars.

---

### Dashboard Screen Components

#### [MODIFY] [dashboard_components.dart](file:///d:/Ngot/lib/firstscreen/dashboard_components/dashboard_components.dart)
- Translate current balance labels, transaction history headers, empty state text, and chart details.
- Update `formatGroupHeading` to include Korean mappings for "Today" and "Yesterday".
- Update `getTxMeta` to return Korean category translations.

## Verification Plan

### Automated Tests
- Extend the unit test suite to verify that language setting updates correctly inside `AppSettingsProvider`.

### Manual Verification
- Launch the application and select Korean during onboarding or in settings.
- Verify that the bottom navigation bar, dashboard components, settings tiles, and personal information screen all display correct Korean translations.
