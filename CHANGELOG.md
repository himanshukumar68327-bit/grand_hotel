# Project update

## Grand Vista Hotel — current improvement pass

- Added a visible maximum nightly-price slider to the home screen alongside room search and category filters.
- Added a reset-filters action and a clear-search control.
- Corrected home pull-to-refresh to refresh the room catalogue rather than the saved-room list.
- Refactored Firestore service into readable, testable code with optional Firebase dependencies for easier testing.
- Kept booking status consistent at `Requested` and included `ownerUid` / `ownerEmail` in booking documents for user-scoped Firestore rules.
- Added client-side validation for guest name, phone, dates, and room capacity.
- Removed temporary debug prints and the unused Cupertino import from the Firestore service.
- Tightened the supplied Firestore rules to check booking ownership and request fields.
- Added unit tests for room model serialization and search/category/price filtering.
- Expanded README with setup, architecture, security, test, and honest demo limitations.

## Validation status

This package was edited from the provided source archive. Run `flutter analyze` and `flutter test` on the development machine after extracting it. Firebase writes must also be verified against the rules actually published in the target Firebase project.
