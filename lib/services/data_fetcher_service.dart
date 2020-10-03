import 'dart:convert';

import 'package:http/http.dart';
import 'package:test_app/models/cat_fact.dart';

class DataFetcher {
  static Future<List<CatFact>> requestFacts(int factsNum) {
    final url = "https://cat-fact.herokuapp.com/facts/random?amount=$factsNum";
    return get(url).then((resp) {
      final decoded = json.decode(resp.body) as List;

      return decoded.map((e) {
        final text = e["text"] ?? "Unknown";
        return CatFact(text);
      }).toList();
    });
  }

  static Future<String> requestCatImageLink() {
    return get("https://api.thecatapi.com/v1/images/search").then((links) {
      if (links.body == null || links.body.isEmpty) return null;
      return json.decode(links.body)[0]["url"] as String;
    });
  }
}
