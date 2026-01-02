AGASANG, Alejandro J.		3CSB					       January 01, 2026
SAMSON, Francis Levy G.
ICS26011
APPLICATIONS DEVELOPMENT AND EMERGING TECHNOLOGIES 3
(MOBILE PROGRAMMING)
Quiz #3: Project Blueprint & Documentation

# Completionist: The Ultimate Steam Companion

Completionist is a video game tracking app that utilizes the Steam API in order to track your games and your achievements in your Steam account. The app also has a built-in guide section that shows you various websites that have guides made by other gamers that you can search for and pick one you’d like. There’s also a built-in note-taking function that allows you to create notes for anything should you wish to do so, and they are saved locally on your phone, so you can access them at any time.

## AI Usage Acknowledgement
The parts of the program that was AI-assisted were the following:
Middleware (e.g. Connecting Steam API to the program, and fetching the proper data)
Guides Page (e.g. Redirecting the links to an in-app browser)
Debugging

## 🛠️ Prerequisites
Before running this project, ensure you have the following:
- Flutter SDK (v3.10 or later)
- Dart Frog CLI
- Docker Desktop
- PostgreSQL Client (optional) - For database management
- Git
- Steam ID for a Steam account that is set to public.

## 🚀 Setup & Installation

### 1. Start the Server
First, you need to turn on the backend. Navigate to the `server` folder:
```bash
cd server
dart_frog dev
```

**Note:** The server runs on `localhost:8080` by default.

### 2. Configure the App
Create a `.env` file in the root directory of your Flutter project:
```env
BASE_URL=http://10.0.2.2:8080
```

**Important Notes:**
- For **Android Emulator**, use `http://10.0.2.2:8080`
- For **iOS Simulator** or **physical devices**, use your computer's local IP (e.g., `http://192.168.1.100:8080`)
- For **production**, replace with your actual server URL

Make sure to load the `.env` file in your app configuration (e.g., using the `flutter_dotenv` package).

### 3. Run the App
Open a new terminal, navigate to the root folder, and run:
```bash
flutter pub get
flutter run
```

## 📱 Features
* **Track your Games**: Users can see their most played games and their owned games within the app on both their Profile page and the Library page.
* **See your Achievements**: Track the achievements you’ve done and not yet done when you click on a game.
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
| GET | `/todos` | Fetches all active tasks |
| GET | `/todos/[id]` | Fetches a specific task by ID |
| POST | `/todos` | Creates a new task (Requires JSON body) |
| DELETE | `/todos/[id]` | Removes a task from the database |

## 📁 Project Structure
```
quicktask/
├── lib/
│ ├── config/
│ │ └── env_config.dart
│ ├── screens/
│ └── main.dart
├── server/
│ └── routes/
├── screenshots/
│ ├── home_screen.png
│ ├── add_task.png
│ └── task_complete.png
├── .env
└── README.md
```
