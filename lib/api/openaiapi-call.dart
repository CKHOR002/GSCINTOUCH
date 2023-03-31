import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Replace YOUR_API_KEY with your actual API key
var apiKey = dotenv.env['OpenAIAPIKey'];
var apiUrl = Uri.https('api.openai.com', '/v1/chat/completions');

void main() async {
// Function to call OpenAI API
  Future<String> generateText(String content, String model) async {
    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode({
          'model': model,
          "messages": [
            {"role": "user", "content": content}
          ]
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body)['choices'][0]['message']['content'];
    } else {
      print(response.statusCode);
      throw Exception(response.body);
    }
  }

  Future<String> printFunction(String text) async {
    return await generateText(
        "Scenario:\nYou are a psychological first aid provider responding to a natural disaster. You encounter a survivor who has lost everything and is visibly distressed. How would you approach the survivor and provide psychological first aid?\n\nResponse to this scenario:\n$text\n\n\nValidate this response by giving yes/no with justification.\n",
        'gpt-3.5-turbo-0301');
  }

  print(await printFunction(
      'Hi, I\'m just here to ask you some questions about what happened. Can you tell me your name, age, and address? We need this information for our report. Sorry to hear about your loss, but we need to get this information first.'));
}
