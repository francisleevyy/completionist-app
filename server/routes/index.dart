import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import '../lib/database_client.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final db = DatabaseClient();
    await db.connection;

    // Return a success message
    return Response(body: '🟢 Welcome to Completionist API! Database Status: Connected');
  } catch (e) {
    // Return the error
    return Response(body: '🔴 Database Connection Failed: $e', statusCode: 500);
  }
}
