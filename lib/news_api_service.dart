import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:knownow/data_model.dart';

class NewsApiService {
  final String apiKey = '485e930613044086bce25630e8945b22';

  Future<List<NewsArticle>> fetchNews({String? category, String? query}) async {
    final isQuerySearch = query != null && query.isNotEmpty;

    final queryParams = {
      'apiKey': apiKey,
      'language': 'en',
      if (isQuerySearch) 'q': query else ...{
        'category': category ?? 'general',
        'country': 'us',
      },
      'pageSize': '100',
      'page': '1',
    };

    final endpoint = isQuerySearch ? '/v2/everything' : '/v2/top-headlines';
    final url = Uri.https('newsapi.org', endpoint, queryParams);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rawArticles = data['articles'];

        final seen = <String>{};

        final uniqueArticles = rawArticles.where((article) {
          final key = '${article['title']}_${article['url']}';
          if (seen.contains(key)) return false;
          seen.add(key);                  
          return true;
        }).map((json) => NewsArticle.fromJson(json)).toList();

        return uniqueArticles;
      } else {
        throw Exception('Failed to load news. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
      throw Exception('An error occurred while fetching news.');
    }
  }
}
