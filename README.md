# Hotel Pages

A Flutter app for viewing hotels with Google login and maps.

## What it does

- Login with Google
- See list of hotels
- View hotel details
- Show hotel location on map
- Logout

## Setup

### Requirements
- Flutter installed (I used 3.32.2)
- Android Studio or VS Code (My version was Android Studio Narwhal | 2025.1.1 Patch 1)
- Phone/emulator/simulator to test (I ran on both iOS (iPhone 16 pro simulator) and Android (Samsung Galaxy A12 - real device))

### Steps to run

1. Clone this repo
```bash
git clone https://github.com/Tharindu127/hotel_pages.git #I used Github for version controlling for better implementation with learning process
cd hotel_pages
```

2. Get dependencies
```bash
flutter pub get
```

3. Firebase setup (for Google login) (currently my own firebase project and setups are integrated)
    - Go to Firebase console and create project
    - Add Android app with package `com.example.hotel_pages`
    - Download `google-services.json` to `android/app/`
    - For iOS: add app with bundle `com.example.hotelPages`, download `GoogleService-Info.plist` to `ios/Runner/`

4. Enable Google Sign-In in Firebase Authentication (you may need to re-integrate `google-services.json` and `GoogleService-Info.plist` after this change.)

5. Run the app
```bash
flutter run
```

6. Issues that may be occurred during run process
    - You may need to add specific licensing for google services and osm map in info.plist (currently added)
    - 

## Testing on new machine

1. Make sure Flutter works: `flutter doctor`
2. Install dependencies: `flutter pub get`
3. Check if it builds: `flutter build apk` (for Android)
4. Run on device: `flutter run`

### If Google login doesn't work:
- Make sure you added the google-services.json file
- Check that Google Sign-In is enabled in Firebase console
- For Android: add SHA-1 key to Firebase (get it with `keytool` command)

## How I built it

### Architecture
I used different patterns for different parts:

**Authentication** 
- Used clean architecture because it's complex:
- BLoC for state management
- Repository pattern for data
- Use cases for business logic
- Dependency injection with GetIt

**Hotels** 
- Kept it simple:
- HTTP service to get data
- Provider for state management (used both BLoc and Provider for better learning process)
- No fancy architecture needed

### Why I did it this way
Started with simple Provider for hotels, the added BLoc for Signing in process as my experience, then learned about clean architecture when building the auth part. Applied the new patterns there but didn't go back to refactor hotels since it was working fine.

## Dependencies used

Main ones:
- `flutter_bloc` - for auth state management
- `provider` - for hotel data
- `firebase_auth` & `google_sign_in` - for login
- `go_router` - for navigation (Applied for the second time, first time which was another personal project done for learning process)
- `flutter_osm_plugin` - for maps (free alternative to Google Maps)
- `http` - for API calls
- `get_it` - dependency injection for auth (learned for the first time)

## What I learned

- Clean architecture patterns
- Provider patterns
- Firebase integration
- Repository pattern
- OSM Map integration with iOS and Android dependencies
- dependency injection
- Error handling with Either types
- OSM doesnt support tooltips in latest versions so I used a dialog popup as an alternative option

## Known issues

- Sometimes map takes time to load
- No offline mode for hotels
- Hotel images cannot be loaded due to server side issue
- Two pointers overlapped in only android app view which couldn't be fixed since everything was working perfectly (nt affected on normal UX)
- Only works with internet connection
- Could use better error messages
- Log reading wordings are AI generated

## Assumptions

- Users have Google account for login
- Internet connection available
- Hotel API stays working
- Android/iOS devices with standard features
---

## References

-https://console.firebase.google.com/u/0/project/hotel-pages-60392/settings/general/android:com.example.hotel_pages (Documentation for Google and Firebase auth integrations in both iOS and Android)
-https://pub.dev/packages/google_sign_in
-https://bloclibrary.dev/
-https://flutter.dev/docs
-https://pub.dev/packages/flutter_osm_plugin

-AI Assistance
 - Used Claude AI for architecture guidance and code review
 - AI helped explain Clean Architecture patterns and Provider implementation with dependency injection
 - Final code written and understood by me with AI guidance