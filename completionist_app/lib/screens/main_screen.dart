import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/side_menu.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'guides_screen.dart';
import 'notes_screen.dart';

class MainScreen extends StatefulWidget {
  final String steamId;

  const MainScreen({super.key, required this.steamId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // TITLES FOR APP BAR
  final List<String> _titles = [
    'Steam Profile',
    'My Library',
    'Game Guides',
    'My Notes',
  ];

  @override
  Widget build(BuildContext context) {
    Widget activeScreen;
    // SWITCH BETWEEN SCREENS BASED ON INDEX
    switch (_currentIndex) {
      case 0:
        activeScreen = ProfileScreen(steamId: widget.steamId);
        break;
      case 1:
        activeScreen = LibraryScreen(steamId: widget.steamId);
        break;
      case 2:
        activeScreen = const GuidesScreen();
        break;
      case 3:
        activeScreen = NotesScreen(steamId: widget.steamId);
        break;
      default:
        activeScreen = ProfileScreen(steamId: widget.steamId);
    }

    return Scaffold(
      // TOP BAR
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: GoogleFonts.poppins()),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,

        // SIGN OUT
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              tooltip: 'Sign Out',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF2C003E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.deepPurpleAccent),
                    ),

                    title: Text(
                      'Sign Out?',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    content: Text(
                      'You will need to enter your Steam ID again.',
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),

                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(ctx);

                          // CLEAR SAVED STEAM ID
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('steamId');

                          // NAVIGATE TO LOGIN SCREEN
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        // SIGN OUT BUTTON
                        child: const Text(
                          'SIGN OUT',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),

      // DRAWER
      drawer: SideMenu(
        onIndexChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // BODY
      body: activeScreen,
    );
  }
}
