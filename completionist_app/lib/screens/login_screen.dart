import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// STATE CLASS
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  // LOGIN METHOD
  Future<void> _login() async {
    final steamId = _idController.text.trim();
    if (steamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Steam ID')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    // VALIDATE STEAM ID
    try {
      await ApiService.getSteamProfile(steamId);

      final prefs = await SharedPreferences.getInstance();

      // PRINTS INTO CONSOLE
      if (_rememberMe) {
        print("DEBUG: Checkbox is ON. Attempting to save ID: $steamId");
        final success = await prefs.setString('steamId', steamId);
        print("DEBUG: Save result: $success");
      } else {
        print("DEBUG: Checkbox is OFF. Removing ID (if any).");
        await prefs.remove('steamId');
      }
      // NAVIGATE TO MAIN SCREEN
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(steamId: steamId)),
        );
      }
    } catch (e) {
      // IF VALIDATION FAILS
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ERROR POPUP DIALOG
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C003E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.deepPurpleAccent, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              "Invalid ID",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "The Steam ID you entered is invalid orcould not be found.\n\nPlease check the ID and ensure your profile is set to Public.",
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // WELCOME TEXT & INPUT
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Completionist',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your Steam ID:",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _idController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'e.g. 76561198...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                const SizedBox(height: 15),

                // REMEMBER ME CHECKBOX
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember me",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    Theme(
                      data: ThemeData(
                        checkboxTheme: CheckboxThemeData(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                              width: 2.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: Colors.deepPurpleAccent,
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // LOGIN BUTTON
                SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'LOGIN',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
