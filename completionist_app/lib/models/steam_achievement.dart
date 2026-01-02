class SteamAchievement {
  final String apiName;
  final String name;
  final String description;
  final bool achieved;

  // Constructors
  SteamAchievement({
    required this.apiName,
    required this.name,
    required this.description,
    required this.achieved,
  });

  // Factory constructor to create a SteamAchievement instance from a JSON map
  factory SteamAchievement.fromJson(Map<String, dynamic> json) {
    return SteamAchievement(
      apiName: json['apiname'],
      name: json['name'] ?? 'Hidden Achievement',
      description: json['description'] ?? '',
      achieved: (json['achieved'] == 1),
    );
  }
}
