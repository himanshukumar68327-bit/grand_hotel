# Grand Vista Hotel

A Flutter hotel-discovery and booking-request app built with **GetX**, **Firebase Authentication**, and **Cloud Firestore**. The project is structured by app infrastructure, controllers, data models/services, feature screens, and reusable widgets.

## Implemented assignment flows

- **Discover rooms:** sample hotel inventory with room images, location, ratings, amenities, room categories, and nightly prices.
- **Search and filter:** search by room name, location, or amenity; filter by category and maximum nightly price; reset filters; pull-to-refresh the sample catalogue.
- **Room details:** room description, capacity, size, amenities, nightly rate, and save-to-favourites action.
- **Booking request:** guest details, check-in/check-out selection, guest-count validation, stay duration and total calculation, submission progress, confirmation reference, and error feedback.
- **Bookings:** user-scoped booking history and cancellation requests.
- **Account:** email/password registration and login, email verification, password reset, profile editing, and logout.
- **Saved rooms:** account-specific saved room records.
- **UI states:** loading, empty, validation, and error feedback across the main flows.
- **Tests:** unit tests for room serialization and home search/category/price filtering.

## Architecture

```text
lib/
  app/
    bindings/       GetX dependency registration
    routes/         Named routes
    theme/          Shared theme and brand colors
  controllers/      Reactive UI state and workflows
  data/
    models/         Room, booking, and user models
    services/       Firebase Auth and Firestore integration
  modules/          Auth, home, rooms, booking, profile, saved rooms
  shared/widgets/   Reusable UI components
```

UI state uses GetX reactive variables and controllers; no `setState` is used in `lib/`.

## Firebase setup

1. Install Flutter stable, Android Studio, Node.js, and Firebase CLI if you intend to deploy rules.
2. In Firebase Console, enable **Authentication → Email/Password** and create a **Cloud Firestore** database.
3. Configure this project for your Firebase project:
   ```powershell
   dart pub global activate flutterfire_cli
   flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
   ```
   The included `lib/firebase_options.dart` and Android `google-services.json` currently target the Firebase project configured by the developer (`chat-app-c9ed3`). Reconfigure them if you use a different project.
4. Review `firestore.rules` carefully, then deploy only to the intended Firebase project:
   ```powershell
   firebase use --add
   firebase deploy --only firestore:rules
   ```
5. Install dependencies and validate:
   ```powershell
   flutter pub get
   flutter analyze
   flutter test
   flutter run
   ```

### Security notes

- Never use `allow read, write: if true` for an app database. It makes user data publicly accessible.
- The supplied Firestore rules restrict reads and writes to the signed-in, email-verified owner and validate the key booking fields. Test them in Firebase Rules Simulator before deployment.
- Booking documents live at `users/{uid}/bookings/{bookingId}` and saved rooms at `users/{uid}/savedRooms/{roomId}`.
- Booking status starts as `Requested`. Cancellation is a limited status update. A real hotel operator/admin confirmation workflow is not included.
- The client refreshes the Firebase ID token after email verification before writing booking data.

## Demo data and limitations

The current room catalogue is a local sample dataset in `lib/data/models/room_model.dart`. It is not connected to a hotel property-management system or a live inventory REST API. This fulfils the sample/mock-data path for the discovery portion of the assignment, but should be described accurately during review.

This is a **booking-request demo**, not a complete production reservation system. It does not include payment processing, server-side price calculation, inventory locking, double-booking prevention, tax/fee calculation, admin confirmation, or a live hotel backend. Those functions should be added with a trusted backend/Cloud Functions before commercial use.

## Suggested end-to-end verification

- Register a test account and verify the email.
- Sign in and confirm home discovery, category/search/price filters, and room details.
- Save a room, then verify it appears in Saved Rooms.
- Submit a valid booking request and verify it appears in Firestore and booking history.
- Try invalid dates, empty guest details, and a guest count above room capacity.
- Cancel a booking and verify only its status changes.
- Sign out, sign in with another account, and verify saved rooms/bookings remain account-specific.
- Test on a real Android device and inspect behavior with no network connection.

## Release checklist

- [ ] Configure the intended Firebase project.
- [ ] Validate and deploy the Firestore rules.
- [ ] `flutter analyze` and `flutter test` pass locally.
- [ ] Test signup, verification, booking, cancellation, profile, and logout on device.
- [ ] Build and install a release APK/AAB.
- [ ] Capture current screenshots or a short demo recording.
- [ ] Review package ID, app icon, privacy policy, and release signing.
- [ ] Be prepared to explain the architecture, security rules, and demo limitations.
