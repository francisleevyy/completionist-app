class SteamProfile {
  final String steamId;
  final String personName;
  final String avatarUrl;
  final String profileUrl;

  // Status: 0=Offline, 1=Online, 2=Away, etc.
  final int personState;

  // Constructors
  SteamProfile({
    required this.steamId,
    required this.personName,
    required this.avatarUrl,
    required this.profileUrl,
    required this.personState,
  });

  // Factory constructor to create a SteamProfile instance from a JSON map
  factory SteamProfile.fromJson(Map<String, dynamic> json) {
    final players = json['response']['players'];

    // Check if players list is empty
    if (players == null || (players as List).isEmpty) {
      throw Exception("User not found! Please check the Steam ID.");
    }

    final player = players[0];

    // Create and return the SteamProfile instance
    return SteamProfile(
      steamId: player['steamid'] ?? '',
      personName: player['personaname'] ?? 'Unknown',
      avatarUrl: player['avatarfull'] ?? '',
      profileUrl: player['profileurl'] ?? '',
      personState: player['personastate'] ?? 0,
    );
  }
}
