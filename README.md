# SurveySync

SurveySync is a production-quality, offline-first census and demographic data collection platform designed for field enumerators. Built with Flutter, it enables efficient data collection, persistent local storage, and real-time demographic analytics without requiring constant internet connectivity.

## Features

### Advanced Authentication
- **Persistent Sessions**: Once logged in, the app remembers you.
- **Local User Registration**: Create multiple enumerator accounts directly on the device.
- **User Management**: Admin-style screen to view and manage registered credentials.

### Comprehensive Survey Management
- **Full CRUD Operations**: Create, Read, Update, and Delete household records.
- **Family Member Tracking**: Add multiple members to each household with detailed demographic fields (Education, Occupation, Marital Status).
- **Expandable UI**: Clean, modern cards that expand to show detailed member information.

### Geographic and Visual Tools
- **GPS Integration**: One-tap real-time coordinate capture for every household.
- **Interactive Map**: Built-in OpenStreetMap visualizing all survey locations with interactive pins.
- **Rich Analytics**: 4 Dynamic charts using fl_chart:
    - Gender Distribution (Pie)
    - Education Distribution (Pie)
    - Age Distribution (Bar)
    - Occupation Distribution (Bar)

### Data Portability and Notifications
- **Direct Download**: Export survey data directly to the device's Downloads folder (Android).
- **Native Sharing**: Share JSON or CSV exports via WhatsApp, Email, or Cloud storage.
- **Styled Notifications**: Professional, brand-colored system alerts for survey milestones.

## Technical Stack
- **Framework**: Flutter (Material 3)
- **State Management**: Provider
- **Local Database**: Hive (Binary storage for high performance)
- **Mapping**: Flutter Map (OpenStreetMap)
- **Permissions**: Geolocator and Permission Handler

## Project Structure
```text
lib/
├── models/      # Data schemas (Household, Member) with Hive adapters
├── services/    # Logic for Database, Auth, Export, and Notifications
├── providers/   # Global state management and analytics logic
├── screens/     # UI for Auth, Dashboard, Surveys, Analytics, and Maps
└── widgets/     # Modular, reusable UI components
```

## Getting Started

1.  **Clone and Install**:
    ```bash
    flutter pub get
    ```

2.  **Generate Database Adapters**:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```

### Default Credentials
- **ID**: admin
- **Password**: admin123
*(Or use the Sign Up button to create your own!)*

---
Developed for field data professionals.
