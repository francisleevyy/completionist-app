import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';
import '../models/steam_profile.dart';
import '../models/steam_game.dart';
import '../models/steam_achievement.dart';

// SERVICE TO INTERACT WITH THE BACKEND API
class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  // NOTES CRUD OPERATIONS
  static Future<List<Note>> fetchNotes(String steamId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes?steamId=$steamId'),
    );

    // Parse and return list of notes
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Create a new note
  static Future<void> createNote(
    String steamId,
    String title,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'steamId': steamId,
        'game_title': title,
        'note_content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create note');
    }
  }

  // Delete a note by ID
  static Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }

  // Update a note's title and content
  static Future<void> updateNote(int id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'game_title': title, 'note_content': content}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  // Toggle note completion status
  static Future<void> toggleNoteStatus(int id, bool isCompleted) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'is_completed': isCompleted}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle status');
    }
  }

  // STEAM: Get User Profile Information
  static Future<SteamProfile> getSteamProfile(String steamId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steam/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'steamId': steamId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SteamProfile.fromJson(data);
    } else {
      throw Exception('Failed to load Steam Profile');
    }
  }

  // STEAM: Get User's Game Library
  static Future<List<SteamGame>> getOwnedGames(String steamId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steam/games'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'steamId': steamId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final gamesList = data['response']['games'] as List;

      // Sorted by playtime in descending order
      final games = gamesList.map((g) => SteamGame.fromJson(g)).toList();
      games.sort((a, b) => b.playtimeForever.compareTo(a.playtimeForever));

      return games;
    } else {
      throw Exception('Failed to load Games Library');
    }
  }

  // STEAM: Get Achievements for a specific game
  static Future<List<SteamAchievement>> getAchievements(
    String steamId,
    int appId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/steam/achievements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'steamId': steamId, 'appId': appId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['playerstats']['achievements'] == null) {
        return [];
      }
      final list = data['playerstats']['achievements'] as List;
      return list.map((a) => SteamAchievement.fromJson(a)).toList();
    } else if (response.statusCode == 403) {
      throw Exception('PrivateProfile');
    } else {
      throw Exception('Failed to load Achievements');
    }
  }
}
