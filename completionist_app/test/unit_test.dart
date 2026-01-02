import 'package:flutter_test/flutter_test.dart';
import '../lib/models/note.dart';
import '../lib/models/steam_game.dart';

void main() {
  group('Part A: Unit Tests (Logic & Data)', () {
    // TEST 1: Happy Path
    // Goal: Test that fromJson correctly parses a valid JSON object.
    test('fromJson parses valid Note JSON correctly', () {
      // Create a valid JSON object
      final json = {
        'id': 1,
        'steam_id': '76561198',
        'game_title': 'Elden Ring',
        'note_content': 'Defeat Malenia',
        'is_completed': true,
      };

      // Convert JSON to a Note object
      final note = Note.fromJson(json);

      // Check if fields are correctly assigned
      expect(note.id, 1);
      expect(note.gameTitle, 'Elden Ring');
      expect(note.isCompleted, true);
    });

    // TEST 2: Edge Case
    // Goal: Test what happens if a field is null or missing (Does it use a default value?).
    test('fromJson handles missing fields by using default values', () {
      // Create JSON with missing 'game_title' and 'is_completed'
      final json = {'id': 2, 'steam_id': '76561198'};

      // Convert JSON to a Note object
      final note = Note.fromJson(json);

      // Check if default values are used
      expect(note.gameTitle, 'Untitled');
      expect(note.isCompleted, false);
    });

    // TEST 3: Logic
    // Goal: Test a utility function (e.g., a function that formats a Date, calculates a total, or validates an email string).
    test('posterUrl getter correctly calculates the image URL', () {
      // Create a Game with a specific App ID (e.g., 10)
      final game = SteamGame(
        appId: 10,
        name: 'Counter-Strike',
        iconUrl: 'icon.jpg',
        playtimeForever: 100,
      );

      // Get the calculated poster URL
      final url = game.posterUrl;

      // Check if the App ID (10) was correctly inserted into the URL
      expect(
        url,
        'https://steamcdn-a.akamaihd.net/steam/apps/10/library_600x900.jpg',
      );
    });
  });
}
