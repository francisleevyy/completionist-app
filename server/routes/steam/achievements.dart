import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;
import '../../lib/cors.dart';

// Replace with your actual Steam API key | PERSONAL KEY: DO NOT expose this key in a public repository
const String _steamApiKey = '94B506DF4B93E7A89EB74720D07DE5A5';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.options) {
    return Response(statusCode: 200, headers: corsHeaders);
  }

  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, headers: corsHeaders);
  }

  try {
    final body = await context.request.json();
    final steamId = body['steamId'];
    final appId = body['appId'];

    if (steamId == null || appId == null) {
      return Response.json(
          statusCode: 400,
          body: {'error': 'Missing steamId or appId'},
          headers: corsHeaders);
    }

    // Fetch achievement status and schema concurrently
    final statusUrl = Uri.parse(
        'http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?appid=$appId&key=$_steamApiKey&steamid=$steamId');

    final schemaUrl = Uri.parse(
        'http://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?key=$_steamApiKey&appid=$appId&l=english');

    final results = await Future.wait([
      http.get(statusUrl),
      http.get(schemaUrl),
    ]);

    final statusResponse = results[0];
    final schemaResponse = results[1];

    // Handle private profiles or inaccessible data
    if (statusResponse.statusCode == 403) {
      return Response.json(
          statusCode: 403,
          body: {'error': 'Profile is set to Friends Only or Private.'},
          headers: corsHeaders);
    }

    if (statusResponse.statusCode != 200 || schemaResponse.statusCode != 200) {
      return Response.json(body: {
        'playerstats': {'achievements': []}
      }, headers: corsHeaders);
    }

    final statusData = jsonDecode(statusResponse.body);
    final schemaData = jsonDecode(schemaResponse.body);

    // Merge achievement status with schema details
    final playerAchievements =
        statusData['playerstats']['achievements'] as List? ?? [];
    final statusMap = {
      for (var item in playerAchievements) item['apiname']: item['achieved']
    };

    final availableGameStats = schemaData['game']['availableGameStats'];
    if (availableGameStats == null ||
        availableGameStats['achievements'] == null) {
      return Response.json(body: {
        'playerstats': {'achievements': []}
      }, headers: corsHeaders);
    }

    final schemaList = availableGameStats['achievements'] as List;

    // Create the merged achievement list
    final mergedList = schemaList.map((schemaItem) {
      final apiName = schemaItem['name'];
      final displayName = schemaItem['displayName'];
      final description = schemaItem['description'] ?? '';

      final isUnlocked = (statusMap[apiName] == 1);

      return {
        'apiname': apiName,
        'name': displayName,
        'description': description,
        'achieved': isUnlocked ? 1 : 0
      };
    }).toList();

    return Response.json(body: {
      'playerstats': {'achievements': mergedList}
    }, headers: corsHeaders);
  } catch (e) {
    print('Server Error: $e');
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}
