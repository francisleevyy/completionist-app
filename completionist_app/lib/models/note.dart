class Note {
  final int id;
  final String steamId;
  final String gameTitle;
  final String noteContent;
  final bool isCompleted;

  // Constructors
  Note({
    required this.id,
    required this.steamId,
    required this.gameTitle,
    required this.noteContent,
    required this.isCompleted,
  });

  // Factory constructor to create a Note instance from a JSON map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      steamId: json['steam_id'] ?? '', 
      gameTitle: json['game_title'] ?? 'Untitled',
      noteContent: json['note_content'] ?? '', 
      isCompleted: json['is_completed'] ?? false,
    );
  }
}
