# SurveySync

SurveySync is an offline-first census and demographic data collection platform designed for enumerators conducting field surveys.

## Features

- **Offline-First**: Uses Hive for local persistence.
- **Household Management**: Full CRUD operations for households and family members.
- **Analytics**: Visual data representation using `fl_chart`.
- **Location Tracking**: Capture GPS coordinates for each household.
- **Export**: Export data to JSON and CSV formats.
- **Modern UI**: Indigo/Teal theme with Material 3.

## Project Structure

- `lib/models`: Data models with Hive adapters.
- `lib/services`: Database, Auth, and Export services.
- `lib/providers`: State management using Provider.
- `lib/screens`: UI screens for Auth, Dashboard, Households, and Analytics.
- `lib/widgets`: Reusable UI components.

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run code generation for Hive adapters:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Login Credentials (Mock)

- **Enumerator ID**: admin
- **Password**: admin123
