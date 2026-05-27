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

## GitHub Actions
Workflow in `.github/workflows/flutter_ci.yml` runs analyze/test and builds signed APK from secrets.

### Required GitHub Secrets
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_PASSWORD`

## Deployment
- Admin panel: Firebase Hosting / Vercel / Netlify (`flutter build web`).
- Farmer app: signed release APK/AAB for Play Store.
