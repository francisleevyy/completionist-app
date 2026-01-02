import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/steam_achievement.dart';
import '../services/api_service.dart';

class AchievementsScreen extends StatefulWidget {
  final String steamId;
  final int appId;
  final String gameName;
  
  // Constructors
  const AchievementsScreen({
    super.key,
    required this.steamId,
    required this.appId,
    required this.gameName,
  });

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

// STATE CLASS
class _AchievementsScreenState extends State<AchievementsScreen> {
  late Future<List<SteamAchievement>> _achievementsFuture;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _achievementsFuture = ApiService.getAchievements(
      widget.steamId,
      widget.appId,
    );
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName, style: GoogleFonts.poppins(fontSize: 18)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
          ),
        ),
        child: FutureBuilder<List<SteamAchievement>>(
          future: _achievementsFuture,
          builder: (context, snapshot) {
            // LOADING STATE
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            // SPECIAL ERROR STATE FOR PRIVATE PROFILES
            else if (snapshot.hasError) {
              final error = snapshot.error.toString();
              if (error.contains('PrivateProfile')) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_person,
                          size: 80,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(height: 20),
                        // OUTPUT MESSAGE IF PRTIVATE PROFILE
                        Text(
                          'Profile is set to Friends Only or Private',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'We cannot see your achievements because your "Game Details" are set to Friends Only or Private.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'To fix this: Go to Steam -> Edit Profile -> Privacy Settings -> Set "Game Details" to Public.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
              // NO ACHIEVEMENTS STATE
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.videogame_asset_off,
                      size: 80,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Achievements',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This game does not have any Steam Achievements.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            // SUCCESS STATE
            final achievements = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final ach = achievements[index];
                return Card(
                  color: ach.achieved
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      ach.achieved ? Icons.emoji_events : Icons.lock,
                      color: ach.achieved ? Colors.amber : Colors.white24,
                      size: 30,
                    ),
                    title: Text(
                      ach.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ach.achieved ? Colors.white : Colors.white60,
                      ),
                    ),
                    subtitle: _buildSubtitle(ach),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  
  // HELPER METHOD FOR SUBTITLE
  Widget? _buildSubtitle(SteamAchievement ach) {
    if (ach.description.isNotEmpty) {
      return Text(
        ach.description,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      );
    }
    if (ach.achieved) {
      return null;
    } else {
      return const Text(
        'Hidden to avoid story spoilers. ;)',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white38),
      );
    }
  }
}
