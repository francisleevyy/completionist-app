import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  // Base URL for the local server
  final baseUrl = Uri.parse('http://localhost:8080');

  group('Part C: API Connection Tests (Integration)', () {
    // TEST 1: GET Request (200 OK)
    // Goal: Test that fetching your list returns a success status.
    test('GET / returns 200 OK status', () async {
      // Send a GET request to the home route
      final response = await http.get(baseUrl);

      //Check that the status code is 200
      expect(response.statusCode, 200);
    });

    // TEST 2: GET Request (Data Check)
    // Goal: Test that the response body actually contains data (list is not null).
    test('GET / returns a valid welcome message/data', () async {
      // Send a GET request to the home route
      final response = await http.get(baseUrl);

      // Check that the response body is not empty
      expect(response.body, isNotEmpty);
      expect(response.body, contains('Welcome'));
    });

    // TEST 3: Error Handling (404 Not Found)
    // Goal: Test that requesting a fake endpoint (e.g., /api/ghosts) correctly returns a 404 status code.
    test('GET /api/ghosts returns 404 Not Found', () async {
      // Send a GET request to a non-existent endpoint
      final response = await http.get(baseUrl.replace(path: '/api/ghosts'));

      // Check that the status code is 404
      expect(response.statusCode, 404);
    });
  });
}
