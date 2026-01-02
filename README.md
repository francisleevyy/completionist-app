AGASANG, Alejandro J. | SAMSON, Francis Levy G. | 3CSB
ICS26011
APPLICATIONS DEVELOPMENT AND EMERGING TECHNOLOGIES 3 (MOBILE PROGRAMMING)
Quiz #3: Project Blueprint & Documentation

# Completionist: The Ultimate Steam Companion

Completionist is a video game tracking app that utilizes the Steam API in order to track your games and your achievements in your Steam account. The app also has a built-in guide section that shows you various websites that have guides made by other gamers that you can search for and pick one you’d like. There’s also a built-in note-taking function that allows you to create notes for anything should you wish to do so, and they are saved locally on your phone, so you can access them at any time.


## 🛠️ Prerequisites
Before running this project, ensure you have the following:
- Flutter SDK (v3.10 or later)
- Dart Frog CLI
- Docker Desktop
- PostgreSQL Client (optional) - For database management
- Git
- Steam ID for a Steam account that is set to public.

## 🚀 Setup & Installation

### 0. Clone the repository
```bash
git clone https://github.com/francisleevyy/completionist-app.git
cd completionist-app
```

### 0.5. Environment Variables
The project uses specific database credentials. Ensure your Docker container matches these, or create a .env file in the 'server' folder if you plan to externalize them:
```env
# PostgreSQL Configuration
POSTGRES_USER=admin
POSTGRES_PASSWORD=password
POSTGRES_DB=completionist_db
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
```

### 1. Start the Server
Open Docker Desktop, open your terminal, and navigate to the `server` folder:
```bash
cd .\server\
docker compose up -d
```

This will start the PostgreSQL database with the configuration specified in docker-compose.yaml.
**Note:** The server runs on `localhost:8080` by default.

### 2. Server Setup
Start the Dart Frog backend server on the same terminal:
```bash
dart pub get
dart_frog dev
```

### 3. Run the Flutter App
Open a new terminal, navigate to the completionist_app folder, and run:
```bash
cd ..
cd .\completionist_app\
flutter pub get
flutter run -d chrome --web-port=3000
```
**Note:** We set the web-port to 3000 so that the 'Remember Me' function would work.

## 📱 Features
* **Steam Profile**: Users can view their real-time Steam status, avatar, and top played games.
* **Track your Games**: Users can see their owned and most played games on the Library Page. They can also search and sort the games by most played and alphabetically.
* **See your Achievements**: Track the achievements you’ve done and not yet done when you click on a game in the library.
* **Make Notes on Your Games**: Make notes to track things you need to do, strategies for the games you make, or anything else you feel like noting down.
* **Feeling Lost? Try a Guide!**: If you’re feeling like you’re lost in a game you’re playing, try looking it up in the Guides page of the app and see the various guides for that game.

## 📸 Screenshots
### Login Page
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Login_Screen.png)

### Profile Page
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Profile_Page.png)

### Library Page
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Library_Page.png)

### Guides Page
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Guides_Page.png)

### Notes Page
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Notes_Page.png)

### Achievements Tracker
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Achievements_Page.png)

### Edit and Delete Notes
![Alt Text](https://github.com/francisleevyy/completionist-app/blob/screenshots/completionist_app/screenshots/Edit_Notes.png)

## 🔗 API Reference
Here are the endpoints available on the Dart Frog server:

| Method | Endpoint | Description |
|--------|----------|-------------|
GET | / | Health Check. Verifies DB connection |
POST | /steam/profile |	Fetches user summary (Name, Avatar, Status |
POST | /steam/games	| Fetches the list of owned games |
POST	| /steam/achievements	| Fetches achievements for a specific game |
GET	| /notes	| Retrieves all notes for a Steam ID |
POST	| /notes	| Creates a new completionist note |
PUT	| /notes/[id]	| Updates note content or completion status |
DELETE	| /notes/[id]	| Removes a note from the database |

## 📁 Project Structure
```
completionist-app/
├── completionist_app/         # Flutter Frontend
│   ├── lib/
│   │   ├── models/
│   │   |   └── note.dart
│   │   |   └── steam_achievement.dart
│   │   |   └── steam_game.dart
│   │   |   └── steam_profile.dart
│   │   ├── screens/
│   │   |   └── achievements_screen.dart
│   │   |   └── guides_screen.dart
│   │   |   └── library_screen.dart
│   │   |   └── login_screen.dart
│   │   |   └── main_screen.dart
│   │   |   └── notes_screen.dart
│   │   |   └── profile_screen.dart
│   │   ├── services/
│   │   |   └── api_service.dart
│   │   ├── widgets/
│   │   |   └── side_menu.dart
│   │   └── main.dart
│   ├── test/                  # Unit, Widget, and Integration tests
│   └── pubspec.yaml
│
├── server/                    # Dart Frog Backend
│   ├── lib/
│   │   └── cors.dart
│   │   └── database_client.dart
│   ├── routes/
│   │   ├── notes/
│   │   |   └── [id].dart
│   │   |   └── index.dart
│   │   ├── steam/
│   │   |   └── achievements.dart
│   │   |   └── games.dart
│   │   |   └── profile.dart
│   │   └── index.dart
│   ├── pubspec.yaml
│   └── analysis_options.yaml
├── screenshots/               # Documentation Images
└── README.md
```

## AI Usage Acknowledgement
The parts of the program that was AI-assisted were the following:
- Middleware (e.g. Connecting Steam API to the program, and fetching the proper data)
- Guides Page (e.g. Redirecting the links to an in-app browser)
- Debugging
