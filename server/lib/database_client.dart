import 'package:postgres/postgres.dart';

class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Connection? _connection;

  factory DatabaseClient() {
    return _instance;
  }

  DatabaseClient._internal();

  Future<Connection> get connection async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    print('Connecting to Docker Database on Port 5433...');

    // Connect to the PostgreSQL database running in Docker
    _connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'completionist_db',
        username: 'admin',
        password: 'password',
        port: 5433,
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    await _connection!.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id SERIAL PRIMARY KEY,
        steam_id TEXT NOT NULL,
        game_title TEXT NOT NULL,
        note_content TEXT NOT NULL,
        is_completed BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('Database Connected and Table Verified!');
    return _connection!;
  }
}
