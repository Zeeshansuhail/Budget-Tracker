import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:budget_tracker/item_model.dart';

import 'failer_model.dart';

class BudgetRespositary {
  final http.Client client;

  static const String _baseUrl = 'https://api.notion.com/v1/';

  BudgetRespositary({http.Client? client}) : client = client ?? http.Client();

  void dispose() {
    client.close();
  }

  Future<List<Item>> getitem() async {
    try {
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2021-08-16',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Failer(message: 'Something got error!');
      }
    } catch (_) {
      throw const Failer(message: 'Something got error!');
    }
  }
}
