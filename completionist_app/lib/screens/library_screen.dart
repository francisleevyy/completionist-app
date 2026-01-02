import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/steam_game.dart';
import '../services/api_service.dart';
import 'achievements_screen.dart';

class LibraryScreen extends StatefulWidget {
  final String steamId;
  const LibraryScreen({super.key, required this.steamId});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // VARIABLES
  List<SteamGame> _allGames = [];
  List<SteamGame> _displayGames = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // SEARCH & SORT CONTROLLERS
  final TextEditingController _searchController = TextEditingController();
  String _sortOption = 'Playtime';

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  // FETCH DATA
  Future<void> _loadGames() async {
    try {
      final games = await ApiService.getOwnedGames(widget.steamId);
      setState(() {
        _allGames = games;
        _displayGames = games;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // FILTER & SORT LOGIC
  void _applyFilters() {
    setState(() {
      // SEARCH FILTER
      final query = _searchController.text.toLowerCase();
      _displayGames = _allGames.where((game) {
        return game.name.toLowerCase().contains(query);
      }).toList();

      // SORTING
      switch (_sortOption) {
        case 'Alphabetical':
          _displayGames.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Playtime':
        default:
          _displayGames.sort(
            (a, b) => b.playtimeForever.compareTo(a.playtimeForever),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage.isNotEmpty)
      return Center(child: Text('Error: $_errorMessage'));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C003E), Color(0xFF512DA8), Color(0xFF7B1FA2)],
        ),
      ),
      child: Column(
        children: [
          // SEARCH BAR & FILTERS
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // SEARCH INPUT
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search Library...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (value) => _applyFilters(),
                ),
                const SizedBox(height: 10),

                // SORT BUTTONS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text(
                        "Sort by: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildFilterChip('Playtime'),
                      const SizedBox(width: 5),
                      _buildFilterChip('Alphabetical'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.white24),
                // STATS & INSTRUCTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Games: ${_allGames.length}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      "Click a game to show achievements!",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // GAME GRID
          Expanded(
            child: _displayGames.isEmpty
                ? const Center(
                    child: Text(
                      "No games found.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: _displayGames.length,
                    itemBuilder: (context, index) {
                      final game = _displayGames[index];

                      // GAME CARD
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
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
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.9),
                                    ],
                                    stops: const [0.6, 1.0],
                                  ),
                                ),
                              ),

                              // HOURS PLAYED DISPLAY
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game.name,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${(game.playtimeForever / 60).toStringAsFixed(1)} hrs',
                                      style: GoogleFonts.poppins(
                                        color: Colors.greenAccent,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // FILTER CHIP WIDGET
  Widget _buildFilterChip(String label) {
    final isSelected = _sortOption == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _sortOption = label;
          });
          _applyFilters();
        }
      },
      selectedColor: Colors.deepPurpleAccent,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }
}
