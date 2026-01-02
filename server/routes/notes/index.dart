import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/database_client.dart';
import '../../lib/cors.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.options) {
    return Response(statusCode: 200, headers: corsHeaders);
  }

  if (context.request.method == HttpMethod.get) {
    return _getNotes(context);
  } else if (context.request.method == HttpMethod.post) {
    return _createNote(context);
  }

  return Response(
      statusCode: HttpStatus.methodNotAllowed, headers: corsHeaders);
}

// READ (FILTERED BY USER ID)
Future<Response> _getNotes(RequestContext context) async {
  try {
    final params = context.request.uri.queryParameters;
    final steamId = params['steamId'];

    if (steamId == null) {
      return Response.json(
          statusCode: 400,
          body: {'error': 'Missing steamId'},
          headers: corsHeaders);
    }

    final db = DatabaseClient();
    final conn = await db.connection;

    final result = await conn.execute(
      'SELECT * FROM notes WHERE steam_id = \$1 ORDER BY created_at DESC',
      parameters: [steamId],
    );

    // Map the result to a list of notes
    final notes = result.map((row) {
      return {
        'id': row[0],
        'game_title': row[2],
        'note_content': row[3],
        'is_completed': row[4],
        'created_at': row[5].toString(),
      };
    }).toList();

    return Response.json(body: notes, headers: corsHeaders);
  } catch (e) {
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}

// CREATE (SAVE WITH USER ID)
Future<Response> _createNote(RequestContext context) async {
  try {
    final body = await context.request.json();
    final steamId = body['steamId'];
    final title = body['game_title'];
    final content = body['note_content'];

    if (steamId == null || title == null || content == null) {
      return Response.json(
          statusCode: 400,
          body: {'error': 'Missing data'},
          headers: corsHeaders);
    }

    final db = DatabaseClient();
    final conn = await db.connection;

    await conn.execute(
      'INSERT INTO notes (steam_id, game_title, note_content) VALUES (\$1, \$2, \$3)',
      parameters: [steamId, title, content],
    );

    return Response.json(body: {'message': 'Saved'}, headers: corsHeaders);
  } catch (e) {
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}
