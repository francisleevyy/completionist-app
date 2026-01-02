import 'dart:convert';
import 'dart:io';

void main() async {
  print('Testing POST request...');
  
  final url = Uri.parse('http://localhost:8080/notes');
  final client = HttpClient();
  
  try {
    final request = await client.postUrl(url);
    request.headers.contentType = ContentType.json;
    
    // The Data we are sending
    final jsonString = jsonEncode({
      "game_title": "Test Game",
      "note_content": "This is a test note from Dart script"
    });
    
    request.write(jsonString);
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Response Status: ${response.statusCode}');
    print('Response Body: $responseBody');
  } catch (e) {
    print('Error: $e');
  }
}
