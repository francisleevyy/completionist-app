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

    if (steamId == null) {
      return Response.json(
          statusCode: 400,
          body: {'error': 'Missing steamId'},
          headers: corsHeaders);
    }

    // Fetch owned games from Steam API
    final url = Uri.parse(
        'http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$_steamApiKey&steamid=$steamId&include_appinfo=1&include_played_free_games=1&format=json');

    final steamResponse = await http.get(url);

    if (steamResponse.statusCode == 200) {
      final data = jsonDecode(steamResponse.body);
      return Response.json(body: data, headers: corsHeaders);
    } else {
      return Response.json(
          statusCode: steamResponse.statusCode,
          body: {'error': 'Steam API Failed'},
          headers: corsHeaders);
    }
  } catch (e) {
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}
