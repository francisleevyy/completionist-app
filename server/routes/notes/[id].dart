import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/database_client.dart';
import '../../lib/cors.dart';

// Handle requests for a specific note identified by its ID
Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.options) {
    return Response(statusCode: 200, headers: corsHeaders);
  }

  if (context.request.method == HttpMethod.delete) {
    return _deleteNote(context, id);
  } else if (context.request.method == HttpMethod.put) {
    return _updateNote(context, id);
  }

  return Response(
      statusCode: HttpStatus.methodNotAllowed, headers: corsHeaders);
}

// Delete a note by its ID
Future<Response> _deleteNote(RequestContext context, String id) async {
  try {
    final db = DatabaseClient();
    final conn = await db.connection;
    await conn.execute('DELETE FROM notes WHERE id = \$1',
        parameters: [int.parse(id)]);
    return Response.json(body: {'message': 'Deleted'}, headers: corsHeaders);
  } catch (e) {
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}

// Update a note by its ID
Future<Response> _updateNote(RequestContext context, String id) async {
  try {
    final body = await context.request.json();

    final title = body['game_title'];
    final content = body['note_content'];
    final isCompleted = body['is_completed'];

    final db = DatabaseClient();
    final conn = await db.connection;

    if (isCompleted != null) {
      await conn.execute(
        'UPDATE notes SET is_completed = \$1 WHERE id = \$2',
        parameters: [isCompleted, int.parse(id)],
      );
    }
    else {
      await conn.execute(
        'UPDATE notes SET game_title = \$1, note_content = \$2 WHERE id = \$3',
        parameters: [title, content, int.parse(id)],
      );
    }

    return Response.json(body: {'message': 'Updated'}, headers: corsHeaders);
  } catch (e) {
    return Response.json(
        statusCode: 500, body: {'error': e.toString()}, headers: corsHeaders);
  }
}
