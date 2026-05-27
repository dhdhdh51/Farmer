# Kisan Ledger

Monorepo containing:
- `apps/farmer_app`: Flutter Android app for farmers.
- `apps/admin_panel`: Flutter Web admin dashboard.
- `firebase/`: Firestore schema, security rules, indexes, and cloud function templates.

## Tech
Flutter + Firebase (Auth, Firestore, Storage, FCM), Riverpod, Hive.

## Quick Start
1. Install Flutter stable (>=3.24).
2. Create Firebase project and enable: Auth (Email/Google), Firestore, Storage, Cloud Messaging.
3. Configure apps with FlutterFire CLI:
   - `cd apps/farmer_app && flutterfire configure`
   - `cd apps/admin_panel && flutterfire configure`
4. Apply firebase rules/indexes:
   - `firebase deploy --only firestore:rules,firestore:indexes,storage`
5. Run farmer app: `cd apps/farmer_app && flutter run`
6. Run admin panel web: `cd apps/admin_panel && flutter run -d chrome`

## Android Release Build (Local)
From repo root:
1. Decode keystore to app folder:
   - `echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > apps/farmer_app/android/app/release.keystore`
2. Option A (recommended): create `apps/farmer_app/android/key.properties`:
   ```properties
   storeFile=app/release.keystore
   storePassword=YOUR_STORE_PASSWORD
   keyAlias=YOUR_KEY_ALIAS
   keyPassword=YOUR_KEY_PASSWORD
   ```
3. Build APK:
   - `cd apps/farmer_app && flutter build apk --release`

## GitHub Actions
Workflow in `.github/workflows/flutter_ci.yml` runs analyze/test and builds signed APK from secrets.

### Required GitHub Secrets
You can use either **A** or **B**:

A) Split secrets
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_PASSWORD`

B) Single auto secret (recommended)
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_PROPERTIES` (multiline)

`ANDROID_KEY_PROPERTIES` value format:
```properties
storeFile=app/release.keystore
storePassword=YOUR_STORE_PASSWORD
keyAlias=YOUR_KEY_ALIAS
keyPassword=YOUR_KEY_PASSWORD
```

## Deployment
- Admin panel: Firebase Hosting / Vercel / Netlify (`flutter build web`).
- Farmer app: signed release APK/AAB for Play Store.
