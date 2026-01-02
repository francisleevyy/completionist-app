import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/steam_profile.dart';
import '../models/steam_game.dart';
import '../services/api_service.dart';
import 'achievements_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String steamId;
  const ProfileScreen({super.key, required this.steamId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<SteamProfile> _profileFuture;
  late Future<List<SteamGame>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ApiService.getSteamProfile(widget.steamId);
    _gamesFuture = ApiService.getOwnedGames(widget.steamId);
  }

  // STATUS HELPERS
  Color _getStatusColor(int state) {
    switch (state) {
      case 1:
        return Colors.greenAccent; // ONLINE
      case 2:
        return Colors.amberAccent; // AWAY
      case 0:
      default:
        return Colors.redAccent; // OFFLINE
    }
  }

  // STATUS TEXT HELPER
  String _getStatusText(int state) {
    switch (state) {
      case 1:
        return 'Online';
      case 2:
        return 'Away';
      case 0:
      default:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
        ),
      ),
      child: FutureBuilder(
        future: Future.wait([_profileFuture, _gamesFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          // LOADING & ERROR STATES
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // DATA RETRIEVED
          final profile = snapshot.data![0] as SteamProfile;
          final allGames = snapshot.data![1] as List<SteamGame>;

          // SORT DATA
          final mostPlayed = List<SteamGame>.from(allGames);
          mostPlayed.sort(
            (a, b) => b.playtimeForever.compareTo(a.playtimeForever),
          );

          // SPLIT INTO TWO ROWS
          final top4Games = mostPlayed.take(4).toList();
          final next4Games = mostPlayed.skip(4).take(4).toList();

          // STATUS
          final statusColor = _getStatusColor(profile.personState);
          final statusText = _getStatusText(profile.personState);

          return ListView(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AVATAR
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(profile.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),

                  // PLAYER DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NAME AND STATUS BOX
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF240b36).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.deepPurpleAccent.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              // NAME
                              Flexible(
                                child: Text(
                                  profile.personName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),

                              // STATUS DOT
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withOpacity(0.6),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),

                              // STATUS TEXT
                              Text(
                                statusText,
                                style: GoogleFonts.poppins(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // STATS BOX
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF240b36).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.deepPurple.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Games Owned: ${allGames.length}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // MOST PLAYED
              _buildSectionTitle('Most Played Games'),
              _buildGameList(context, top4Games),
              if (next4Games.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildGameList(context, next4Games),
              ],
            ],
          );
        },
      ),
    );
  }

  // HELPERS
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            const Shadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  // GAME LIST WIDGET
  Widget _buildGameList(BuildContext context, List<SteamGame> games) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.2)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AchievementsScreen(
                    steamId: widget.steamId,
                    appId: game.appId,
                    gameName: game.name,
                  ),
                ),
              );
            },
            // GAME CARD
            child: Container(
              width: 105,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        game.posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.videogame_asset,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    game.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
