class SteamGame {
  final int appId;
  final String name;
  final String iconUrl;
  final int playtimeForever;

  // Constructors
  SteamGame({
    required this.appId,
    required this.name,
    required this.iconUrl,
    required this.playtimeForever,
  });

  // Factory constructor to create a SteamGame instance from a JSON map
  factory SteamGame.fromJson(Map<String, dynamic> json) {
    final iconHash = json['img_icon_url'];
    final appId = json['appid'];

    // Construct the icon URL using the appId and iconHash
    return SteamGame(
      appId: appId,
      name: json['name'] ?? 'Unknown Game',
      iconUrl:
          'http://media.steampowered.com/steamcommunity/public/images/apps/$appId/$iconHash.jpg',
      playtimeForever: json['playtime_forever'] ?? 0,
    );
  }
  
  // VIDEO GAME POSTERS
  String get posterUrl =>
      'https://steamcdn-a.akamaihd.net/steam/apps/$appId/library_600x900.jpg';
}
